version 1.0

import "task_fastqc.wdl" as fastqc
import "task_fastp.wdl" as fastp
import "task_samtools.wdl" as samtools
import "wf_centrifuge.wdl" as centrifuge
import "wf_bbduk.wdl" as bbduk
import "wf_minimap2.wdl" as minimap2
import "wf_ivar.wdl" as ivar
import "task_qualimap.wdl" as qualimap
import "wf_bam_metrics.wdl" as bam_metrics
import "task_collect_wgs_metrics.wdl" as wgsQC
import "wf_mosdepth.wdl" as mosdepth
import "task_freyja.wdl" as freyja
import "task_multiqc.wdl" as multiqc

workflow wastewater {
  input {
    Array[File]+ reads1
    Array[File]+ reads2
    Array[String]+ samplenames
    File reference
    Map[String, String] dockerImages
    # bbduk
    File adapters
    File phiX
    File polyA
    File primers
    Int disk_size
    # freyja
    Int depth_cut_off
    Int min_base_quality
    String pathogen
    # minimap2
    Int threads
    String memory
    # centrifuge
    Boolean run_centrifuge
    Array[File]+ indexFiles
    Int disk_multiplier
    # bam metrics
    String outputDir = "."
    Boolean collectAlignmentSummaryMetrics = true
    Boolean meanQualityByCycle = true
    Array[File]+? targetIntervals
    File? ampliconIntervals
    # ivar
    File primers_bed
    Int min_trimmed_length
    Int min_quality_score
    Boolean include_reads_with_no_primers
    Boolean keep_reads_qc_fail
  }

  scatter ( indx in range(length(reads1)) ) {

    call fastqc.task_fastqc {
      input:
      forwardReads = reads1[indx],
      reverseReads = reads2[indx],
      docker = dockerImages["fastqc"],
      threads = threads,
      memory = memory
    }
    
    call fastp.task_fastp {
      input:
      read1 = reads1[indx],
      read2 = reads2[indx],
      sample_id = samplenames[indx],
      docker_image = dockerImages["fastp"],
      threads = threads,
      memory = memory
    }
    
    call bbduk.wf_bbduk {
      input:
      read1 = reads1[indx],
      read2 = reads2[indx],
      primers = primers,
      adapters = adapters,
      phiX = phiX,
      polyA = polyA,
      samplename = samplenames[indx],
      disk_size = disk_size,	
      threads = threads,
      memory = memory,
      docker = dockerImages["bbduk"]
    }
    
    if ( run_centrifuge ) {
      call centrifuge.wf_centrifuge {
	input:
	read1 = wf_bbduk.clean_read1,
	read2 = wf_bbduk.clean_read2,
	samplename = samplenames[indx],
	indexFiles = indexFiles,
	docker = dockerImages["centrifuge"],
	threads = threads,
	memory = memory,
	disk_size = disk_size,
	disk_multiplier = disk_multiplier
      }
    } 
      
    call minimap2.wf_minimap2 {
      input:
      read1 = task_fastp.clean_read1,
      read2 = task_fastp.clean_read2,
      reference = reference,
      samplename = samplenames[indx],
      threads = threads,
      memory = memory,
      dockerImages = {"samtools": dockerImages["samtools"], "minimap": dockerImages["minimap"]},
      outputPrefix = samplenames[indx]
    }
    
    call ivar.wf_ivar {
      input:
      raw_bam = wf_minimap2.bam,
      sample_name = samplenames[indx],
      primers_bed = primers_bed,
      min_trimmed_length = min_trimmed_length,
      min_quality_score = min_quality_score,
      include_reads_with_no_primers = include_reads_with_no_primers,
      keep_reads_qc_fail = keep_reads_qc_fail,
      threads = threads,
      docker_samtools = dockerImages["samtools"],
      docker_ivar = dockerImages["ivar"]
    }
    
    call qualimap.task_qualimap_bamqc {
      input:
      bam = wf_minimap2.bam,
      threads = threads,
      memory = memory,
      docker = dockerImages["qualimap"],
      samplename = samplenames[indx]
    }
    
    call samtools.DictAndFaidx {
      input:
      inputFile = reference,
      memory = memory,
      docker = dockerImages["samtools"]
    }

    call bam_metrics.wf_bam_metrics {
      input:
      bam = wf_minimap2.bam,
      bamIndex = wf_minimap2.bai,
      outputDir = outputDir,
      referenceFasta = reference,
      referenceFastaFai = DictAndFaidx.outputFastaFai,
      referenceFastaDict = DictAndFaidx.outputFastaDict,
      collectAlignmentSummaryMetrics = collectAlignmentSummaryMetrics,
      meanQualityByCycle = meanQualityByCycle,
      targetIntervals = targetIntervals,
      ampliconIntervals = ampliconIntervals,
      dockerImages = { "samtools": dockerImages["samtools"], "picard": dockerImages["picard"] }
    }
    
    call wgsQC.task_collect_wgs_metrics {
      input:
      bam = wf_minimap2.bam,
      reference = reference
    }

    call mosdepth.task_mosdepth {
      input:
      input_bam = wf_minimap2.bam,
      input_bai = wf_minimap2.bai,
      bed_file = primers_bed,
      threads = threads,
      mapq = 20,
      prefix = samplenames[indx],
      memory = memory,
      disk = "10GB",
      docker = dockerImages["mosdepth"]
    }
    
    call freyja.task_freyja {
      input:
      samplename = samplenames[indx],
      depth_cut_off = depth_cut_off,
      min_base_quality = min_base_quality,
      bam = wf_ivar.final_trimmed_bam,
      bai = wf_ivar.final_trimmed_bam_index,
      reference = reference,
      pathogen = pathogen,
      docker = dockerImages["freyja"],
      memory = memory
    }
  }
  
  Array[File] reports_fastq = flatten([ task_fastqc.forwardData, task_fastqc.reverseData, task_fastp.report_json])
  #Array[File] reports_bam   = flatten([ task_qualimap_bamqc.genome_results, task_collect_wgs_metrics.collectMetricsOutput, task_qualimap_bamqc.raw_data_qualimapReport])
  Array[File] reports_bam   = flatten([ task_qualimap_bamqc.genome_results, task_collect_wgs_metrics.collectMetricsOutput])
  Array[File] reports_ivar  = flatten([ wf_ivar.flagstat, wf_ivar.idxstats, wf_ivar.stats])
  Array[File] reports_bbduk = flatten([ wf_bbduk.adapter_stats, wf_bbduk.phiX_stats, wf_bbduk.polyA_stats, wf_bbduk.primer_stats])
  Array[File?] reports_centrifuge = flatten([wf_centrifuge.krakenStyleTSV])
  Array[File] reports_freyja = flatten([task_freyja.demixing_output])
  Array[File?] reports_mosdepth = flatten([task_mosdepth.global_dist, task_mosdepth.regions_depth])
  Array[File] reports_picard = flatten(wf_bam_metrics.picardMetricsFiles)
  Array[File] allReports = select_all(flatten([reports_fastq, reports_bam, reports_ivar, reports_bbduk, reports_freyja, reports_centrifuge, reports_mosdepth, reports_picard]))
  call multiqc.task_multiqc {
    input:
    inputFiles = allReports,
    outputPrefix = "multiqc",
    docker = dockerImages["multiqc"],
    memory = memory
  }
  
  output {
    # fastqc
    Array[File] forwardHtml = task_fastqc.forwardHtml
    Array[File] reverseHtml = task_fastqc.reverseHtml

    # fastp
    Array[File] fastp_clean_reads1 = task_fastp.clean_read1
    Array[File] fastp_clean_reads2 = task_fastp.clean_read2
    Array[File] reports_json = task_fastp.report_json
    Array[File] reports_html = task_fastp.report_html

    # bbduk
    Array[File] bbduk_clean_reads1 = wf_bbduk.clean_read1
    Array[File] bbduk_clean_reads2 = wf_bbduk.clean_read2
    Array[File] adapter_stats = wf_bbduk.adapter_stats
    Array[File] primer_stats = wf_bbduk.primer_stats
    Array[File] polyA_stats = wf_bbduk.polyA_stats
    Array[File] phiX_stats = wf_bbduk.phiX_stats

    # centrifuge
    Array[File?] centrifuge_classification = wf_centrifuge.classificationTSV
    Array[File?] centrifuge_kraken_style = wf_centrifuge.krakenStyleTSV
    Array[File?] centrifuge_summary = wf_centrifuge.summaryReportTSV

    # minimap
    Array[File] bam = wf_minimap2.bam
    Array[File] bai = wf_minimap2.bai
    
    # ivar
    Array[File] final_trimmed_bam = wf_ivar.final_trimmed_bam
    Array[File] final_trimmed_bam_index = wf_ivar.final_trimmed_bam_index
    Array[File] flagstat = wf_ivar.flagstat
    Array[File] idxstats = wf_ivar.idxstats
    Array[File] stats = wf_ivar.stats
    Array[File] log_ivar = wf_ivar.log
    Array[File] errlog_ivar = wf_ivar.errlog

    # qualimap
    Array[File] qc_report = task_qualimap_bamqc.report
    Array[Array[File]] qc_data = task_qualimap_bamqc.raw_data_qualimapReport

    # bam metrics
    #File flagstats = wf_bam_metrics.flagstats
    Array[Array[File]] picardMetricsFiles = wf_bam_metrics.picardMetricsFiles
    Array[Array[File]] targetedPcrMetrics = wf_bam_metrics.targetedPcrMetrics 
    Array[Array[File]] reports_bam_metrics = wf_bam_metrics.reports

    # mosdepth
    Array[File] coverage_per_base = task_mosdepth.per_base_depth
    Array[File] coverage_summary = task_mosdepth.summary_output
    Array[File] coverage_global_dist = task_mosdepth.global_dist
    Array[File?] coverage_regions_depth = task_mosdepth.regions_depth
    
    # gatk
    Array[File] collect_wgs_output_metrics = task_collect_wgs_metrics.collectMetricsOutput
    
    # freyja
    Array[File] variants_output = task_freyja.variants
    Array[File] depths_output = task_freyja.depths
    Array[File] demixing_output = task_freyja.demixing_output

    # multiqc
    File report = task_multiqc.report
  }

  meta {
    author: "Dieter Best"
    email: "Dieter.Best@cdph.ca.gov"
    description: "## pipeline to analyze wastewater samples for a pathogen"
  }

  parameter_meta {
    ## inputs
    reads1: {description: "Input fastq file with forward reads", category: "required"}
    reads2: {description: "Input fastq file with reverse reads", category: "required"}
    samplename: {description: "Sample name", category: "required"}
    reference: {description: "Reference sequence for pathogen to be anlyzed", category: "required"}
    pathogen: {description: "Name of pathogen to be anlyzed", category: "required"}
    ## output
    classificationTSV: {description: "Output tsv file with read classification"}
    summaryReportTSV: {description: "Output tsv file with summary of classification"}
    krakenStyleTSV: {description: "Output tsv file with read classification kraken style"}
  }
}

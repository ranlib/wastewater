version 1.0

import "wf_bam_metrics.wdl" as bam_metrics
import "task_samtools.wdl" as samtools
import "task_multiqc.wdl" as multiqc
import "wf_mosdepth.wdl" as mosdepth

workflow wf_bam_metrics_list {
  input {
    Array[File] bams
    String outputDir = "."
    File reference
    Boolean collectAlignmentSummaryMetrics = true
    Boolean meanQualityByCycle = true
    Array[File]+? targetIntervals
    File? ampliconIntervals
    Map[String, String] dockerImages
    String memory = "260GB"
    Int threads = 12
  }

  call samtools.DictAndFaidx {
    input:
    inputFile = reference,
    memory = memory,
    docker = dockerImages["samtools"]
  }
  
  scatter ( indx in range(length(bams)) ) {
    call samtools.Sort {
      input:
      inputBam = bams[indx],
      outputPath =  basename(basename(bams[indx], ".bam"), ".sorted")  + ".sorted.bam",
      threads = threads,
      docker = dockerImages["samtools"]
    }

    call bam_metrics.wf_bam_metrics {
      input:
      bam = Sort.outputBam,
      bamIndex = Sort.outputBamIndex,
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

    call mosdepth.task_mosdepth {
      input:
      input_bam = Sort.outputBam,
      input_bai = Sort.outputBamIndex,
      prefix = basename(basename(bams[indx], ".bam"), ".sorted"),
      bed_file = ampliconIntervals,
      threads = threads,
      mapq = 20,
      memory = memory,
      disk = "10GB",
      docker = dockerImages["mosdepth"]
    }

  }

  Array[File] reports_pcr  = flatten(wf_bam_metrics.targetedPcrMetrics)
  Array[File] reports_picard = flatten(wf_bam_metrics.picardMetricsFiles)
  Array[File?] reports_mosdepth = flatten([task_mosdepth.global_dist, task_mosdepth.regions_depth])
  Array[File] reports_all = select_all(flatten([reports_picard, reports_pcr, reports_mosdepth]))
  call multiqc.task_multiqc {
    input:
    inputFiles = reports_all,
    outputPrefix = "multiqc",
    docker = dockerImages["multiqc"],
    memory = memory
  }

  output {
    #File flagstats = wf_bam_metrics.flagstats
    Array[Array[File]] picardMetricsFiles = wf_bam_metrics.picardMetricsFiles
    Array[Array[File]] targetedPcrMetrics = wf_bam_metrics.targetedPcrMetrics 
    Array[Array[File]] reports_bam_metrics = wf_bam_metrics.reports
    # mosdepth
    Array[File] coverage_per_base = task_mosdepth.per_base_depth
    Array[File] coverage_summary = task_mosdepth.summary_output
    Array[File] coverage_global_dist = task_mosdepth.global_dist
    Array[File?] coverage_regions_depth = task_mosdepth.regions_depth
    # multiqc
    File report_multiqc = task_multiqc.report
  }
  
}

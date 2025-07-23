version 1.0

import "task_fastqc.wdl" as fastqc
import "task_fastp.wdl" as fastp
import "wf_minimap2.wdl" as minimap2
import "task_freyja.wdl" as freyja
import "task_multiqc.wdl" as multiqc
import "wf_centrifuge.wdl" as centrifuge
import "wf_qualimap.wdl" as qualimap

workflow wastewater {
  input {
    File read1
    File read2
    File reference
    Int depth_cut_off
    Int min_base_quality
    String docker_centrifuge = "dbest/centrifuge:v1.0.4.2"
    String docker_kreport = "dbest/centrifuge:v1.0.4.2"
    String docker_fastqc
    String docker_fastp
    String docker_minimap2
    String docker_freyja
    String docker_multiqc
    String docker_qualimap
    String samplename
    String pathogen
    # minimap2
    Int threads = 1
    String memory = "32GB"
    # centrifuge
    Boolean run_centrifuge = true
    Array[File]+ indexFiles
  }

  call fastqc.task_fastqc {
    input:
    forwardReads = read1,
    reverseReads = read2,
    docker = docker_fastqc
  }

  call fastp.task_fastp {
    input:
    read1 = read1,
    read2 = read2,
    sample_id = samplename,
    docker_image = docker_fastp
  }
  
  if ( run_centrifuge ) {
    call centrifuge.wf_centrifuge {
      input:
      read1 = task_fastp.clean_read1,
      read2 = task_fastp.clean_read2,
      samplename = samplename,
      indexFiles = indexFiles,
      docker_centrifuge = docker_centrifuge,
      docker_kreport = docker_kreport,
      threads = threads
    }
  } 

  call minimap2.wf_minimap2 {
    input:
    read1 = task_fastp.clean_read1,
    read2 = task_fastp.clean_read2,
    reference = reference,
    samplename = samplename,
    threads = threads,
    memory = memory,
    outputPrefix = samplename,
    docker = docker_minimap2
  }

  call qualimap.task_qualimap_bamqc {
    input:
    bam = wf_minimap2.bam,
    threads = threads,
    memory = memory,
    docker = docker_qualimap,
    samplename = samplename
  }

  call freyja.task_freyja {
    input:
    samplename = samplename,
    depth_cut_off = depth_cut_off,
    min_base_quality = min_base_quality,
    bam = wf_minimap2.bam,
    bai = wf_minimap2.bai,
    reference = reference,
    pathogen = pathogen,
    docker = docker_freyja
  }

  Array[File] allReports = flatten([
  select_all([
  task_fastqc.forwardData,
  task_fastqc.reverseData,
  task_fastp.report_json,
  wf_centrifuge.krakenStyleTSV,
  task_qualimap_bamqc.report,
  task_freyja.demixing_output
  ])
  ])
  call multiqc.task_multiqc {
    input:
    inputFiles = allReports,
    outputPrefix = samplename,
    docker = docker_multiqc
  }
  
  output {
    # fastqc
    File forwardHtml = task_fastqc.forwardHtml
    File reverseHtml = task_fastqc.reverseHtml

    # fastp
    File clean_reads1 = task_fastp.clean_read1
    File clean_reads2 = task_fastp.clean_read2
    File reports_json = task_fastp.report_json
    File reports_html = task_fastp.report_html

    # centrifuge
    File? centrifuge_classification = wf_centrifuge.classificationTSV
    File? centrifuge_kraken_style = wf_centrifuge.krakenStyleTSV
    File? centrifuge_summary = wf_centrifuge.summaryReportTSV

    # qualimap
    File qc_report = task_qualimap_bamqc.report
    
    # freyja
    File variants_output = task_freyja.variants
    File depths_output = task_freyja.depths
    File demixing_output = task_freyja.demixing_output

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
    read1: {description: "Input fastq file with forward reads", category: "required"}
    read2: {description: "Input fastq file with reverse reads", category: "required"}
    samplename: {description: "Sample name", category: "required"}
    reference: {description: "Reference sequence for pathogen to be anlyzed", category: "required"}
    pathogen: {description: "Name of pathogen to be anlyzed", category: "required"}
    ## output
    classificationTSV: {description: "Output tsv file with read classification"}
    summaryReportTSV: {description: "Output tsv file with summary of classification"}
    krakenStyleTSV: {description: "Output tsv file with read classification kraken style"}
  }
}

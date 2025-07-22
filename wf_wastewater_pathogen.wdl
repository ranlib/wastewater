version 1.0

import "task_fastqc.wdl" as fastqc
import "task_fastp.wdl" as fastp
import "wf_minimap2.wdl" as minimap2
import "task_freyja.wdl" as freyja
import "task_multiqc.wdl" as multiqc

workflow wastewater {
  input {
    File read1
    File read2
    File reference
    Int depth_cut_off
    Int min_base_quality
    String docker_fastqc
    String docker_fastp
    String docker_minimap2
    String docker_freyja
    String docker_multiqc
    String samplename
    String pathogen
    Int threads = 1
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
  
  call minimap2.wf_minimap2 {
    input:
    read1 = task_fastp.clean_read1,
    read2 = task_fastp.clean_read2,
    reference = reference,
    samplename = samplename,
    threads = threads,
    outputPrefix = samplename,
    docker = docker_minimap2
  }
  
  call freyja.task_freyja {
    input:
    samplename = samplename,
    depth_cut_off = depth_cut_off,
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
  task_freyja.demixing_output
  ])
  ])
  call multiqc.task_multiqc {
    input:
    inputFiles = allReports,
    outputPrefix = samplename
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
    
    # freyja
    File variants_output = task_freyja.variants
    File depths_output = task_freyja.depths
    File demixing_output = task_freyja.demixing_output

    # multiqc
    File report = task_multiqc.report
  }
}

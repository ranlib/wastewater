version 1.0

import "task_multiqc.wdl" as multiqc
import "task_qualimap.wdl" as qualimap

workflow wf_qualimap_bamqc {
  input {
    Array[File] bams
    Array[String] samplenames
    Int threads = 1
    String memory = "32GB"
    String docker_qualimap = "staphb/qualimap:2.3"
  }

  scatter ( indx in range(length(bams)) ) {
    call qualimap.task_qualimap_bamqc {
      input:
      bam = bams[indx],
      samplename = samplenames[indx],
      memory = memory,
      threads = threads,
      docker = docker_qualimap
    }
  }

  #Array[File] reports_bam   = flatten([ task_qualimap_bamqc.genome_results, task_qualimap_bamqc.raw_data_qualimapReport])
  Array[File] reports_bam   = flatten(task_qualimap_bamqc.raw_data_qualimapReport)
  call multiqc.task_multiqc {
    input:
    inputFiles = reports_bam,
    outputPrefix = "multiqc",
    docker = "multiqc/multiqc:v1.30",
    memory = memory
  }

  output {
    Array[File] report = task_qualimap_bamqc.report
    Array[File] genome_results = task_qualimap_bamqc.genome_results
    Array[Array[File]] raw_data_qualimapReport = task_qualimap_bamqc.raw_data_qualimapReport
    # multiqc
    File report_multiqc = task_multiqc.report
  }
}



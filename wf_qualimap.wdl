version 1.0

workflow wf_qualimap_bamqc {
  input {
    Array[File] bams
    Array[String] samplenames
    Int threads = 1
    String memory = "32GB"
    String docker_qualimap = "staphb/qualimap:2.3"
  }

  scatter ( indx in range(length(bams)) ) {
    call task_qualimap_bamqc {
      input:
      bam = bams[indx],
      samplename = samplenames[indx],
      memory = memory,
      threads = threads,
      docker = docker_qualimap
    }
  }

  output {
    Array[File] report = task_qualimap_bamqc.report
    Array[File] genome_results = task_qualimap_bamqc.genome_results
    Array[Array[File]] raw_data_qualimapReport = task_qualimap_bamqc.raw_data_qualimapReport
  }
}

task task_qualimap_bamqc {
  input {
    File bam
    Int threads = 1
    String memory = "32GB" 
    String docker = "staphb/qualimap:2.3"
    String samplename
  }

  command <<<
    set -euxo pipefail
    qualimap bamqc \
    -bam ~{bam} \
    -outdir ~{samplename}_qualimap_report \
    -nt ~{threads} \
    -outformat PDF:HTML \
    --sequencing-protocol non-strand-specific \
    --collect-overlap-pairs
  >>>

  output {
    File report = "${samplename}_qualimap_report/qualimapReport.html"
    File genome_results = "${samplename}_qualimap_report/genome_results.txt"
    Array[File] raw_data_qualimapReport = glob("${samplename}_qualimap_report/raw_data_qualimapReport/*")
  }

  runtime {
    docker: docker
    cpu: threads
    memory: memory
  }
}


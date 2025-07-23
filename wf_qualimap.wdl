version 1.0

workflow wf_qualimap_bamqc {
  input {
    File bam
    Int threads = 1
    String memory = "32GB"
    String docker_qualimap = "staphb/qualimap:2.3"
    String samplename
  }

  call task_qualimap_bamqc {
    input:
    bam = bam,
    memory = memory,
    threads = threads,
    docker = docker_qualimap,
    samplename = samplename
  }

  output {
    File report = task_qualimap_bamqc.report
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
      -nt ~{threads}
  >>>

  output {
    File report = "${samplename}_qualimap_report/qualimapReport.html"
  }

  runtime {
    docker: docker
    cpu: threads
    memory: memory
  }
}


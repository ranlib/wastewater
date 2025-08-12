version 1.0

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

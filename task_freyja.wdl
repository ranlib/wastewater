version 1.0

task task_freyja {
  input {
    Int depth_cut_off = 0
    Int min_base_quality = 0
    String samplename
    String pathogen
    String docker = "dbest/freyja:v2.0.0"
    File reference
    File bam
    File bai
  }
  
  command <<<
    set -euxo pipefail
    freyja update --pathogen ~{pathogen}
    freyja variants ~{bam} --variants ~{samplename}.tsv --depths ~{samplename}.depth --minq ~{min_base_quality} --ref ~{reference}
    freyja demix ~{samplename}.tsv ~{samplename}.depth --output ~{samplename }.demixed.tsv --pathogen ~{pathogen} --depthcutoff ~{depth_cut_off} --autoadapt
    #--adapt 0.035
  >>>
    
  output {
    File variants = samplename+ ".tsv"
    File depths = samplename + ".depth"
    File demixing_output = samplename + ".demixed.tsv"
  }
  
  runtime {
    docker: docker
  }
}  

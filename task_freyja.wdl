version 1.0

task task_freyja {
  input {
    Int depth_cut_off = 0
    Int min_base_quality = 0
    String samplename
    String pathogen
    String docker = "dbest/freyja:v2.0.1"
    Int disk_size = 100
    String memory
    File reference
    File bam
    File bai
  }
  
  command <<<
    set -euxo pipefail
    freyja variants ~{bam} --variants ~{samplename}.tsv --depths ~{samplename}.depth --minq ~{min_base_quality} --ref ~{reference}
    if [ ~{pathogen} == "SARS-CoV-2" ] ; then
       freyja update --pathogen ~{pathogen}
       freyja demix ~{samplename}.tsv ~{samplename}.depth --output ~{samplename}.demixed.tsv --depthcutoff ~{depth_cut_off} --autoadapt
       #--adapt 0.035
    else
       mkdir -p ~{pathogen}
       freyja update --pathogen ~{pathogen} --outdir ~{pathogen}
       BARCODES=$(find ~{pathogen} -name "*.csv")
       LINEAGES=$(find ~{pathogen} -name "*.yml")
       freyja demix ~{samplename}.tsv ~{samplename}.depth --output ~{samplename}.demixed.tsv --pathogen ~{pathogen} --lineageyml ${LINEAGES} --barcodes ${BARCODES} --depthcutoff ~{depth_cut_off} --autoadapt
       #--adapt 0.035
    fi
  >>>
    
  output {
    File variants = samplename+ ".tsv"
    File depths = samplename + ".depth"
    File demixing_output = samplename + ".demixed.tsv"
  }
  
  runtime {
    docker: docker
    memory: memory
    cpu: 1
    disks: "local-disk " + disk_size + " SSD"
  }
}  

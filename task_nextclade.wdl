version 1.0

task RunNextclade {
  input {
    File fasta
    String dataset_name = "sars-cov-2"
    String verbosity = "warn" # other options are: "off" "error" "info" "debug" and "trace"
    String docker = "nextstrain/nextclade:3.13.0"
    String memory =  "2G"
    Int cpu = 1
    Int disk_size = 50
  }

  command <<<
    set -euxo pipefail
    mkdir -p output_dir
    nextclade run \
    --dataset-name ~{dataset_name} \
    --output-all output_dir \
    --verbosity ~{verbosity} \
    --jobs ~{cpu} \
    ~{fasta}
  >>>

  output {
    Array[File] output_all = glob("output_dir/*")
    File aligned_fasta = "output_dir/nextclade.aligned.fasta"
    File result_tsv = "output_dir/nextclade.tsv"
    File result_json = "output_dir/nextclade.json"
  }

  runtime {
    docker: docker
    memory: memory
    cpu: cpu
    disks:  "local-disk " + disk_size + " SSD"
  }
}

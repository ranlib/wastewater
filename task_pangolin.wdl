version 1.0

task run_pangolin {
  input {
    File query_fasta
    String output_file_name = "lineage_report.csv"
    String alignment_file_name = "alignment.fasta"
    Boolean output_alignment = false
    Boolean expanded_lineage = false
    String docker_image = "staphb/pangolin:4.3.1-pdata-1.33"
    String memory = "4G"
    Int cpu = 1
  }

  command <<<
    set -euxo pipefail
    mkdir -p output_dir
    pangolin \
    ~{query_fasta} \
    --threads ~{cpu} \
    --outfile output_dir/~{output_file_name} \
    ~{if output_alignment then "--alignment --alignment-file output_dir/" + alignment_file_name else ""} \
    ~{if expanded_lineage then "--expanded-lineage" else ""}
  >>>

  output {
    File lineage_report = "output_dir/" + output_file_name
    File? alignment_file = select_first([ "output_dir/" + alignment_file_name ])
  }

  runtime {
    docker: docker_image
    memory: memory
    cpu: cpu
  }
}

version 1.0

import "task_nextclade.wdl" as nextclade

workflow NextcladeWorkflow {
  input {
    File fasta
  }

  call nextclade.RunNextclade {
    input:
      fasta = fasta,
  }

  output {
    Array[File] output_all = RunNextclade.output_all
    File alignedFasta = RunNextclade.aligned_fasta
    File resultTsv = RunNextclade.result_tsv
    File resultJson = RunNextclade.result_json
  }
}

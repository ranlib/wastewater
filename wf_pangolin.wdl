version 1.0

import "task_pangolin.wdl" as pangolin_task

workflow pangolin_workflow {
  input {
    File input_fasta
    String? output_file_name
    String? alignment_file_name
    Boolean output_alignment = false
    Boolean expanded_lineage = false
  }

  call pangolin_task.run_pangolin {
    input:
      query_fasta = input_fasta,
      output_file_name = select_first([output_file_name, "lineage_report.csv"]),
      alignment_file_name = select_first([alignment_file_name, "alignment.fasta"]),
      output_alignment = output_alignment,
      expanded_lineage = expanded_lineage
  }

  output {
    File lineage_report = run_pangolin.lineage_report
    File? alignment_file = run_pangolin.alignment_file
  }
}

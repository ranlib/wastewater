version 1.0

import "task_seqkit.wdl" as seqkit_task

workflow seqkit_stats_workflow {
  input {
    Array[File]+ input_file
    Array[Int]? n_values
    Boolean? all_stats
    Boolean? use_basename
    String? fq_encoding
    String? gap_letters
    Boolean? skip_err
    Boolean? skip_file_check
    String? stdin_label
    Boolean? tabular
    Int threads
    String out_file
  }

  call seqkit_task.seqkit_stats_task {
    input:
    input_file = input_file,
    out_file = out_file,
    all_stats = all_stats,
    use_basename = use_basename,
    fq_encoding = fq_encoding,
    gap_letters = gap_letters,
    skip_err = skip_err,
    skip_file_check = skip_file_check,
    stdin_label = stdin_label,
    tabular = tabular,
    threads = threads
  }

  output {
    File seqkit_stats_result = seqkit_stats_task.stats_output
  }
}

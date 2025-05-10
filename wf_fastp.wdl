version 1.0

import "task_fastp.wdl" as fastp

workflow wf_fastp {
  input {
    Array[File] input_reads1
    Array[File] input_reads2
    String sample_id_prefix
    String adapter_sequence = "AGATCGGAAGAGCACACGTC"
    String adapter_sequence_r2 = "AGATCGGAAGAGCGTCGTGTAGGAAAGAGTG"
    Int threads = 2
    Int trim_front1 = 0
    Int trim_tail1 = 0
    Int trim_front2 = 0
    Int trim_tail2 = 0
    Boolean cutadapt_compatible = false
    Boolean umi = false
    String umi_loc = "read1"
    Int umi_len = 0
    Boolean disable_quality_filtering = false
    Int q = 20
    Int unqualified_percent_limit = 40
    Int n_base_limit = 5
    Int low_complexity_filter = 0
    Int complexity_threshold = 40
    Boolean filter_by_index = false
    Boolean correction = false
    Boolean proper_pairs_only = false
    Boolean merge_pe = false
    Boolean output_read1 = true
    Boolean output_read2 = true
    String extra_options = ""
    String docker_image = "biocontainers/fastp:v0.20.1_cv1"
  }

  scatter (i in range(length(input_reads1))) {
    call fastp.task_fastp {
      input:
      read1 = input_reads1[i],
      read2 = input_reads2[i],
      sample_id = "${sample_id_prefix}_${i+1}",
      outprefix = "${sample_id_prefix}_${i+1}",
      adapter_sequence = adapter_sequence,
      adapter_sequence_r2 = adapter_sequence_r2,
      threads = threads,
      trim_front1 = trim_front1,
      trim_tail1 = trim_tail1,
      trim_front2 = trim_front2,
      trim_tail2 = trim_tail2,
      cutadapt_compatible = cutadapt_compatible,
      umi = umi,
      umi_loc = umi_loc,
      umi_len = umi_len,
      disable_quality_filtering = disable_quality_filtering,
      q = q,
      unqualified_percent_limit = unqualified_percent_limit,
      n_base_limit = n_base_limit,
      low_complexity_filter = low_complexity_filter,
      complexity_threshold = complexity_threshold,
      filter_by_index = filter_by_index,
      correction = correction,
      proper_pairs_only = proper_pairs_only,
      merge_pe = merge_pe,
      output_read1 = output_read1,
      output_read2 = output_read2,
      extra_options = extra_options,
      docker_image = docker_image
    }
  }

  output {
    Array[File] clean_reads1 = task_fastp.clean_read1
    Array[File?] clean_reads2 = task_fastp.clean_read2
    Array[File] reports_json = task_fastp.report_json
    Array[File] reports_html = task_fastp.report_html
  }
}

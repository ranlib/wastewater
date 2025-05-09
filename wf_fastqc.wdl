version 1.0

import "./task_fastqc.wdl" as fastqc

workflow wf_fastqc {
  input {
    File forwardReads
    File reverseReads
    File? adapters
    File? contaminants
    File? limits
    Int threads = 1
  }

  call fastqc.task_fastqc {
    input:
    forwardReads = forwardReads,
    reverseReads = reverseReads,
    contaminants = contaminants,
    adapters = adapters,
    limits = limits,
    threads = threads
  }

  output {
    File forwardHtml = task_fastqc.forwardHtml
    File reverseHtml = task_fastqc.reverseHtml
    File forwardZip = task_fastqc.forwardZip
    File reverseZip = task_fastqc.reverseZip
    File forwardSummary = task_fastqc.forwardSummary
    File reverseSummary = task_fastqc.reverseSummary
    File forwardData = task_fastqc.forwardData
    File reverseData = task_fastqc.reverseData
    Int numberForwardReads = task_fastqc.numberForwardReads
    Int numberReverseReads = task_fastqc.numberForwardReads
  }

  meta {
    author: "Dieter Best"
    email: "Dieter.Best@cdph.ca.gov"
    description: "## QC for fastq files"
  }

  parameter_meta {
    forwardReads: {description: "fastq file with forward reads.", category: "required"}
    reverseReads: {description: "fastq file with reverse reads.", category: "required"}
    threads: {description: "Number of cpus for this process.", category: "optional"}
    adapters: {description: "tsv file with adapter names in column 1 and sequences in column 2.", category: "optional"}
    contaminants: {description: "tsv file with adapter names in column 1 and sequences in column 2.", category: "optional"}
    limits: {description: "File with a set of warn/error limits for the various modules", category: "optional"}
    
    forwardHtml: {description: "Output html file for forward reads."}
    reverseHtml: {description: "Output html file for reverse reads."}
    forwardZip: {description: "Output zip file for forward reads."}
    reverseZip: {description: "Output zip file for reverse reads."}
    forwardData: {description: "Output data file for forward reads."}
    reverseData: {description: "Output data file for reverse reads."}
    forwardSummary: {description: "Output summary file for forward reads."}
    reverseSummary: {description: "Output summary file for reverse reads."}
    numberForwardReads: {description: "Number of forward reads."}
    numberReverseReads: {description: "Number of reverse reads."}
  }

}

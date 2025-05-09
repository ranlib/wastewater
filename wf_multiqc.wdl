version 1.0

import "./task_multiqc.wdl" as multiQC

workflow wf_multiqc {
  input {
    Array[File] inputFiles
    String outputPrefix
  }

  call multiQC.task_multiqc {
    input:
    inputFiles = inputFiles,
    outputPrefix = outputPrefix
  }

  output {
    File report = task_multiqc.report
  }

  meta {
    author: "Dieter Best"
    email: "Dieter.Best@cdph.ca.gov"
    description: "## Multi QC workflow \n\n Produce QC reports for a number of tasks"
  }

  parameter_meta {
    ## inputs
    inputFiles: {description: "List of input files to run QC on.", category: "required"}
    outputPrefix: {description: "output prefix.", category: "required"}
    ## output
    report: {description: "output html file."}
  }
}

version 1.0

import "wf_bam_metrics.wdl" as bam_metrics
import "task_samtools.wdl" as samtools

workflow wf_bam_metrics_list {
  input {
    Array[File] bams
    String outputDir = "."
    File reference
    Boolean collectAlignmentSummaryMetrics = true
    Boolean meanQualityByCycle = true
    Array[File]+? targetIntervals
    File? ampliconIntervals
    Map[String, String] dockerImages
    String memory = "260GB"
    Int threads = 12
  }

  call samtools.DictAndFaidx {
    input:
    inputFile = reference,
    memory = memory,
    docker = dockerImages["samtools"]
  }
  
  scatter ( indx in range(length(bams)) ) {
    call samtools.Sort {
      input:
      inputBam = bams[indx],
      outputPath =  basename(basename(bams[indx], ".bam"), ".sorted")  + ".sorted.bam",
      threads = threads,
      docker = dockerImages["samtools"]
    }

    call bam_metrics.wf_bam_metrics {
      input:
      bam = Sort.outputBam,
      bamIndex = Sort.outputBamIndex,
      outputDir = outputDir,
      referenceFasta = reference,
      referenceFastaFai = DictAndFaidx.outputFastaFai,
      referenceFastaDict = DictAndFaidx.outputFastaDict,
      collectAlignmentSummaryMetrics = collectAlignmentSummaryMetrics,
      meanQualityByCycle = meanQualityByCycle,
      targetIntervals = targetIntervals,
      ampliconIntervals = ampliconIntervals,
      dockerImages = { "samtools": dockerImages["samtools"], "picard": dockerImages["picard"] }
    }
  }
  
  output {
    #File flagstats = wf_bam_metrics.flagstats
    Array[Array[File]] picardMetricsFiles = wf_bam_metrics.picardMetricsFiles
    Array[Array[File]] targetedPcrMetrics = wf_bam_metrics.targetedPcrMetrics 
    Array[Array[File]] reports_bam_metrics = wf_bam_metrics.reports
  }
  
}

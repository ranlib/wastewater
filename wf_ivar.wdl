version 1.0

import "./task_samtools.wdl" as samtools

task task_ivar_trim {
    input {
      File input_bam
      File primer_bed
      String sample_id
      Int? min_length
      Int? min_quality
      Int? sliding_window_width
      Int threads = 1
      Boolean include_no_primers = false
      Boolean keep_qc_fail = false
      File? amplicon_info_file # Optional: -f flag, primer pair information file
      String memory = "32GB"
      String docker = "staphb/ivar:1.4.4"
    }

    command <<<
        set -euxo pipefail
        ivar trim \
            -i ~{input_bam} \
            -b ~{primer_bed} \
            -p ~{sample_id}.trimmed \
            ~{"-f " + amplicon_info_file} \
            ~{"-m " + min_length} \
            ~{"-q " + min_quality} \
            ~{"-s " + sliding_window_width} \
            ~{true=" -e" false="" include_no_primers} \
            ~{true=" -k" false="" keep_qc_fail} > ~{sample_id}_ivar_trim.log 2> ~{sample_id}_ivar_trim.errlog
    >>>

    output {
      File trimmed_bam = "${sample_id}.trimmed.bam"
      File log = "${sample_id}_ivar_trim.log"
      File errlog = "${sample_id}_ivar_trim.errlog"
    }

    runtime {
        docker: docker
        memory: memory
        cpu: threads
    }
}

workflow wf_ivar {
    input {
        File raw_bam
        File primers_bed
        String sample_name
        Int? min_trimmed_length
        Int? min_quality_score
        Int? sliding_window_size
        Boolean include_reads_with_no_primers
        Boolean keep_reads_qc_fail
        File? amplicon_information_file
    }

    call task_ivar_trim {
        input:
            input_bam = raw_bam,
            primer_bed = primers_bed,
            sample_id = sample_name,
            min_length = min_trimmed_length,
            min_quality = min_quality_score,
            sliding_window_width = sliding_window_size,
            include_no_primers = include_reads_with_no_primers,
            keep_qc_fail = keep_reads_qc_fail,
            amplicon_info_file = amplicon_information_file
    }

    call samtools.Sort {
      input:
      inputBam = task_ivar_trim.trimmed_bam
    }

    call samtools.Flagstat {
      input:
      inputBam = Sort.outputBam
    }

    output {
      File final_trimmed_bam = Sort.outputBam
      File final_trimmed_bam_index = Sort.outputBamIndex
      File flagstat = Flagstat.flagstat
      File log = task_ivar_trim.log
      File errlog = task_ivar_trim.errlog
    }
}

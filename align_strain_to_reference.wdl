version 1.0

workflow align_strain_to_reference {
  input {
    File baseline_fasta
    File strain_fasta
    String strain_name
  }

  # Index reference once
  call minimap2_index_reference {
    input:
      baseline_fasta = baseline_fasta
  }

  call minimap2_align {
    input:
      reference_mmi = minimap2_index_reference.mmi,
      strain_fasta = strain_fasta,
      strain_name = strain_name
  }

  call sam_to_bam {
    input:
      sam = minimap2_align.sam,
      strain_name = strain_name
  }

  call samtools_sort_index {
    input:
      unsorted_bam = sam_to_bam.unsorted_bam,
      strain_name = strain_name
  }

  output {
    File bam = samtools_sort_index.bam
    File bai = samtools_sort_index.bai
  }
}

task minimap2_index_reference {
  input {
    File baseline_fasta
  }

  command <<<
    set -euxo pipefail
    minimap2 -d reference.mmi ~{baseline_fasta}
  >>>

  output {
    File mmi = "reference.mmi"
  }

  runtime {
    docker: "staphb/minimap2:2.30"
    cpu: 2
    memory: "4G"
  }
}

task minimap2_align {
  input {
    File reference_mmi
    File strain_fasta
    String strain_name
  }

  command <<<
    set -euxo pipefail
    minimap2 -ax asm5 \
      ~{reference_mmi} \
      ~{strain_fasta} \
      > ~{strain_name}.sam
  >>>

  output {
    File sam = "~{strain_name}.sam"
  }

  runtime {
    docker: "staphb/minimap2:2.30"
    cpu: 2
    memory: "4G"
  }
}

task sam_to_bam {
  input {
    File sam
    String strain_name
  }

  command <<<
    set -euxo pipefail
    samtools view -bS ~{sam} \
      -o ~{strain_name}.unsorted.bam
  >>>

  output {
    File unsorted_bam = "~{strain_name}.unsorted.bam"
  }

  runtime {
    docker: "dbest/samtools:v1.23"
    cpu: 1
    memory: "2G"
  }
}

task samtools_sort_index {
  input {
    File unsorted_bam
    String strain_name
  }

  command <<<
    set -euxo pipefail

    samtools sort ~{unsorted_bam} \
      -o ~{strain_name}.bam

    samtools index ~{strain_name}.bam
  >>>

  output {
    File bam = "~{strain_name}.bam"
    File bai = "~{strain_name}.bam.bai"
  }

  runtime {
    docker: "dbest/samtools:v1.23"
    cpu: 2
    memory: "4G"
  }
}

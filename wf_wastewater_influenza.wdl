version 1.0

workflow freyja_influenza {
  input {
    String samplename
    File R1
    File R2
    Int cpus = 32
    Int depth_cut_off = 0
    Int min_base_quality = 0
    Array[String] pathogens = ["H1N1", "H3N2", "H5Nx", "FLU-B-VIC"]
  }

  call clone_barcodes

  scatter (pathogen in pathogens) {
    call align_sample {
      input:
        pathogen = pathogen,
        R1 = R1,
        R2 = R2,
        cpus = cpus,
        barcodes_tar = clone_barcodes.barcodes_tar
    }

    call sort_bam {
      input:
        sam = align_sample.sam,
        cpus = cpus,
        samplename = samplename,
        pathogen = pathogen
    }

    call freyja_variants {
      input:
        bam = sort_bam.bam,
        reference = align_sample.reference,
        min_base_quality = min_base_quality,
        samplename = samplename,
        pathogen = pathogen
    }

    call freyja_demix {
      input:
        variants = freyja_variants.variants,
        depths = freyja_variants.depths,
        barcodes = align_sample.barcodes,
        depth_cut_off = depth_cut_off,
        samplename = samplename,
        pathogen = pathogen
    }

    call freyja_boot {
      input:
        variants = freyja_variants.variants,
        depths = freyja_variants.depths,
        barcodes = align_sample.barcodes,
        cpus = cpus,
        samplename = samplename,
        pathogen = pathogen
    }
  }

  call aggregate_demix {
    input:
      demix_files = freyja_demix.demix,
      output_prefix = samplename
  }

  output {
    Array[File] sorted_bams = sort_bam.bam
    Array[File] variants = freyja_variants.variants
    Array[File] demix = freyja_demix.demix
    Array[File] lineages = freyja_boot.lineages
    Array[File] summarized = freyja_boot.summarized
    File aggregate = aggregate_demix.aggregate
  }
}

# -------------------- TASKS --------------------

task clone_barcodes {
  command <<<
    set -euxo
    git clone https://github.com/andersen-lab/Freyja-barcodes.git
    tar -czvf barcodes.tar.gz Freyja-barcodes
  >>>

  output {
    File barcodes_tar = "barcodes.tar.gz"
  }

  runtime {
    docker: "dbest/git:v1.1"
  }
}

task align_sample {
  input {
    String pathogen
    File R1
    File R2
    Int cpus
    File barcodes_tar
  }

  command <<<
    set -euxo
    tar -xf ~{barcodes_tar} 
    reference_fasta="Freyja-barcodes/~{pathogen}/latest/reference.fasta"
    minimap2 -a -t ~{cpus} -o minimap2.sam ${reference_fasta} ~{R1} ~{R2}
  >>>

  output {
    File sam = "minimap2.sam"
    File reference = "Freyja-barcodes/~{pathogen}/latest/reference.fasta"
    File barcodes = "Freyja-barcodes/~{pathogen}/latest/barcode.csv"
  }

  runtime {
    docker: "dbest/minimap2:2.30"
    cpu: cpus
  }
}

task sort_bam {
  input {
    File sam
    Int cpus
    String samplename
    String pathogen
  }

  command <<<
    set -euxo
    samtools sort -@ ~{cpus} -o ~{samplename}_~{pathogen}_sorted.bam ~{sam}
  >>>

  output {
    File bam = "${samplename}_${pathogen}_sorted.bam"
  }

  runtime {
    docker: "dbest/samtools:v1.22.1"
    cpu: cpus
  }
}

task freyja_variants {
  input {
    File bam
    File reference
    Int min_base_quality
    String samplename
    String pathogen
  }

  command <<<
    set -euxo
    freyja variants \
      --ref ~{reference} \
      --variants ~{samplename}_~{pathogen}_variants.tsv \
      --depths ~{samplename}_~{pathogen}_depths.tsv \
      --minq ~{min_base_quality} \
      ~{bam}
  >>>

  output {
    File variants = "~{samplename}_~{pathogen}_variants.tsv"
    File depths = "~{samplename}_~{pathogen}_depths.tsv"
  }

  runtime {
    docker: "dbest/freyja:v2.0.1"
  }
}

task freyja_demix {
  input {
    File variants
    File depths
    File barcodes
    Int depth_cut_off
    String samplename
    String pathogen
  }

  command <<<
    set -euxo
    lines=$(wc -l < ~{variants})
    if [ ! -s "~{variants}" ] || [ $lines -le 1 ]; then
      echo "Empty variants file, skipping demix."
      touch ~{samplename}_~{pathogen}_demix.tsv
    else
      freyja demix \
        --output ~{samplename}_~{pathogen}_demix.tsv \
        --depthcutoff ~{depth_cut_off} \
        --autoadapt \
        --barcodes ~{barcodes} \
        ~{variants} ~{depths}
    fi
  >>>

  output {
    File demix = "~{samplename}_~{pathogen}_demix.tsv"
  }

  runtime {
    docker: "dbest/freyja:v2.0.1"
  }
}

task freyja_boot {
  input {
    File variants
    File depths
    File barcodes
    Int cpus
    String samplename
    String pathogen
  }

  command <<<
    set -euxo
    lines=$(wc -l < ~{variants})
    if [ ! -s "~{variants}" ] || [ $lines -le 1 ]; then
      echo "Skipping bootstrap; empty variants."
      touch ~{samplename}_~{pathogen}_lineages.csv
      touch ~{samplename}_~{pathogen}_summarized.csv
    else
      freyja boot \
        --nt ~{cpus} \
        --nb 500 \
        --output_base ~{samplename}_~{pathogen} \
        --barcodes ~{barcodes} \
        ~{variants} ~{depths} || {
          echo "freyja boot failed."
          touch ~{samplename}_~{pathogen}_lineages.csv
          touch ~{samplename}_~{pathogen}_summarized.csv
      }
    fi
  >>>

  output {
    File lineages = "~{samplename}_~{pathogen}_lineages.csv"
    File summarized = "~{samplename}_~{pathogen}_summarized.csv"
  }

  runtime {
    docker: "dbest/freyja:v2.0.1"
    cpu: cpus
  }
}

task aggregate_demix {
  input {
    Array[File] demix_files
    String output_prefix
  }

  command <<<
    set -euxo
    mkdir -p demix_dir empty_dir
    for f in ~{sep=" " demix_files}; do
      if [ -s "$f" ] && [ $(wc -l < "$f") -gt 1 ]; then
        cp "$f" demix_dir/
      else
        cp "$f" empty_dir/
      fi
    done

    if [ -z "$(ls -A demix_dir)" ]; then
      echo "Directory is empty."
      touch ~{output_prefix}_freyja_aggregate.tsv
    else
      echo "Directory is not empty."
      freyja aggregate demix_dir/ --output ~{output_prefix}_freyja_aggregate.tsv
    fi
    
  >>>

  output {
    File aggregate = "~{output_prefix}_freyja_aggregate.tsv"
  }

  runtime {
    docker: "dbest/freyja:v2.0.1"
  }
}

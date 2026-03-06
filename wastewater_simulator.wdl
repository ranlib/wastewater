version 1.0

import "align_strain_to_reference.wdl" as aligner

workflow simulate_wastewater_multi_strain {

    input {
        Array[String] sample_ids

        # One FASTA per SARS strain (e.g., Wuhan, Delta, Omicron)
        File sars_baseline_fasta
        Array[File] sars_fastas
        Array[String] sars_strain_names

        File background_fasta
        File? host_fasta

        String illumina_platform = "MSv3"
        Int read_length = 150
        Int mean_insert = 300
        Int insert_sd = 30

        # Per-sample fold coverage for background + host
        Array[Float] background_fold_coverage
        Array[Float] host_fold_coverage

        # Per-sample samplerates for background + host
        Array[Float] background_samplerate
        Array[Float] host_samplerate

        # Per-sample, per-strain coverage and samplerate
        # Dimensions: [sample][strain]
        Array[Array[Float]] sars_fold_coverage_matrix
        Array[Array[Float]] sars_samplerate_matrix

        Boolean simulate_fragmentation = true
        Int frag_mean = 300
        Int frag_sd = 150

        Boolean simulate_primer_dropout = true
        File primer_bed          # e.g., ARTIC V4 BED
        Array[Array[Int]] dropout_tiles # e.g., [3, 7, 12] tile indices to drop per sample
    }

    scatter (i in range(length(sample_ids))) {

        # --- Simulate each SARS strain for this sample ---
        scatter (j in range(length(sars_fastas))) {

            # Step 1: primer dropout
            if (simulate_primer_dropout) {
                call mask_primer_tiles {
                    input:
                    reference_fasta = sars_fastas[j],
                    primer_bed = primer_bed,
                    dropout_tiles = dropout_tiles[i],
                    prefix = sample_ids[i] + ".sars." + sars_strain_names[j]
                }
                call compute_coverage_holes {
                    input:
                    baseline_fasta = sars_baseline_fasta,
                    dropout_bed = mask_primer_tiles.dropout_bed,
                    sample_name = sample_ids[i],
                    prefix = sample_ids[i] + ".sars." + sars_strain_names[j]
                }
            }

            # Step 2: fragmentation
            if (simulate_fragmentation) {
                call fragment_reference {
                    input:
                    reference_fasta = select_first([mask_primer_tiles.masked_fasta, sars_fastas[j]]),
                    frag_mean = frag_mean,
                    frag_sd = frag_sd,
                    prefix = sample_ids[i] + ".sars." + sars_strain_names[j]
                }
            }

            call simulate_art as simulate_sars {
                input:
                reference_fasta = select_first([fragment_reference.fragmented_fasta, mask_primer_tiles.masked_fasta, sars_fastas[j]]),
                platform = illumina_platform,
                read_length = read_length,
                mean_insert = mean_insert,
                insert_sd = insert_sd,
                fold_coverage = sars_fold_coverage_matrix[i][j],
                prefix = sample_ids[i] + ".sars." + sars_strain_names[j]
            }

            call subsample_reads as subsample_sars {
                input:
                r1 = simulate_sars.r1,
                r2 = simulate_sars.r2,
                samplerate = sars_samplerate_matrix[i][j],
                prefix = sample_ids[i] + ".sars." + sars_strain_names[j] + ".sub"
            }

            call aligner.align_strain_to_reference {
                input:
                baseline_fasta = sars_baseline_fasta,
                strain_fasta = sars_fastas[j],
                strain_name = sars_strain_names[j]
            }
            
            call call_truth_variants {
                input:
                baseline_fasta = sars_baseline_fasta,
                bam = align_strain_to_reference.bam,
                strain_name = sars_strain_names[j]
            }
            
        } # end loop jsars

        call merge_truth_vcfs {
            input:
            truth_vcfs = call_truth_variants.truth_vcf,
            truth_vcfs_index = call_truth_variants.truth_vcf_index,
            sample_id = sample_ids[i]
        }

        # --- Background ---
        call simulate_art as simulate_background {
            input:
            reference_fasta = background_fasta,
            platform = illumina_platform,
            read_length = read_length,
            mean_insert = mean_insert,
            insert_sd = insert_sd,
            fold_coverage = background_fold_coverage[i],
            prefix = sample_ids[i] + ".background"
        }

        call subsample_reads as subsample_background {
            input:
            r1 = simulate_background.r1,
            r2 = simulate_background.r2,
            samplerate = background_samplerate[i],
            prefix = sample_ids[i] + ".background.sub"
        }

        # --- Optional host ---
        if (defined(host_fasta)) {
            call simulate_art as simulate_host {
                input:
                reference_fasta = select_first([host_fasta]),
                platform = illumina_platform,
                read_length = read_length,
                mean_insert = mean_insert,
                insert_sd = insert_sd,
                fold_coverage = host_fold_coverage[i],
                prefix = sample_ids[i] + ".host"
            }

            call subsample_reads as subsample_host {
                input:
                r1 = simulate_host.r1,
                r2 = simulate_host.r2,
                samplerate = host_samplerate[i],
                prefix = sample_ids[i] + ".host.sub"
            }
        }

        # --- Merge all FASTQs ---
        Array[File] r1_host = select_all(if defined(host_fasta) then [subsample_host.r1_sub] else [])
        Array[File] r2_host = select_all(if defined(host_fasta) then [subsample_host.r2_sub] else [])
        call merge_fastqs {
            input:
            r1s = flatten([subsample_sars.r1_sub,[subsample_background.r1_sub],r1_host]),
            r2s = flatten([subsample_sars.r2_sub,[subsample_background.r2_sub],r2_host]),
            sample_id = sample_ids[i]
        }

        # --- FastQC per sample ---
        call fastqc {
            input:
            r1 = merge_fastqs.out_r1,
            r2 = merge_fastqs.out_r2
        }

        # --- Truth metadata per sample ---
        call write_truth_metadata {
            input:
            sample_id = sample_ids[i],
            sars_strain_names = sars_strain_names,
            sars_fold_coverage = sars_fold_coverage_matrix[i],
            sars_samplerate = sars_samplerate_matrix[i],
            background_fold_coverage = background_fold_coverage[i],
            background_samplerate = background_samplerate[i],
            host_fold_coverage = host_fold_coverage[i],
            host_samplerate = host_samplerate[i],
            truth_vcfs = call_truth_variants.truth_vcf
        }

    } # end loop over samples

    call multiqc {
        input:
        fastqc_zips = flatten(fastqc.out_zips)
    }

    call combine_truth_metadata {
        input:
        truth_csvs = write_truth_metadata.truth_csv
    }

    output {
        Array[File] wastewater_R1 = merge_fastqs.out_r1
        Array[File] wastewater_R2 = merge_fastqs.out_r2
        Array[File] truth_csvs = write_truth_metadata.truth_csv
        Array[File] truth_vcf = merge_truth_vcfs.merged_truth_vcf
        Array[File] truth_vcf_index = merge_truth_vcfs.merged_truth_vcf_index
        Array[Array[File?]] coverage_hole_regions = compute_coverage_holes.hole_regions
        Array[Array[File?]] coverage_hole_metrics = compute_coverage_holes.hole_metrics_json
        File combined_truth_manifest = combine_truth_metadata.truth_manifest
        File multiqc_report = multiqc.report_html
    }
} # end workflow

# ------------------- Tasks -------------------

task simulate_art {
    input {
        File reference_fasta
        String platform
        Int read_length
        Int mean_insert
        Int insert_sd
        Float fold_coverage
        String prefix
        String memory = "10GB"
        Int threads = 4
    }

    command <<<
        set -euxo
        art_illumina -ss ~{platform} -sam -i ~{reference_fasta} \
        -p -l ~{read_length} -f ~{fold_coverage} \
        -m ~{mean_insert} -s ~{insert_sd} \
        -o ~{prefix}_
    >>>

    output {
        File r1 = "~{prefix}_1.fq"
        File r2 = "~{prefix}_2.fq"
    }

    runtime {
        docker: "rpetit3/illumina-simulation"
        cpu: threads
        memory: memory
    }
}

task subsample_reads {
    input {
        File r1
        File r2
        Float samplerate
        String prefix
    }

    command <<<
        set -euxo
        reformat.sh in1=~{r1} in2=~{r2} \
        out1=~{prefix}_1.fq out2=~{prefix}_2.fq \
        samplerate=~{samplerate}
    >>>

    output {
        File r1_sub = "~{prefix}_1.fq"
        File r2_sub = "~{prefix}_2.fq"
    }

    runtime {
        docker: "staphb/bbtools:39.75"
        cpu: 1
        memory: "2G"
    }
}

task merge_fastqs {
    input {
        Array[File] r1s
        Array[File] r2s
        String sample_id
    }

    command <<<
        set -euxo
        cat ~{sep=' ' r1s} > ~{sample_id}_R1.fastq
        cat ~{sep=' ' r2s} > ~{sample_id}_R2.fastq
        gzip ~{sample_id}_R1.fastq ~{sample_id}_R2.fastq
    >>>

    output {
        File out_r1 = "~{sample_id}_R1.fastq.gz"
        File out_r2 = "~{sample_id}_R2.fastq.gz"
    }

    runtime {
        docker: "ubuntu:25.04"
        cpu: 1
        memory: "1G"
    }
}

task fastqc {
    input {
        File r1
        File r2
        Int threads = 12
    }

    command <<<
        set -euxo
        fastqc ~{r1} ~{r2} --threads ~{threads} --outdir .
    >>>

    output {
        Array[File] out_zips = glob("*_fastqc.zip")
    }

    runtime {
        docker: "staphb/fastqc:0.12.1"
        cpu: threads
        memory: "10G"
    }
}

task multiqc {
    input {
        Array[File] fastqc_zips
    }

    command <<<
        mkdir qc
        cp ~{sep=' ' fastqc_zips} qc/
        multiqc qc -o .
    >>>

    output {
        File report_html = "multiqc_report.html"
    }

    runtime {
        docker: "multiqc/multiqc:v1.33"
        cpu: 1
        memory: "2G"
    }
}

task write_truth_metadata {
    input {
        String sample_id
        Array[String] sars_strain_names
        Array[Float] sars_fold_coverage
        Array[Float] sars_samplerate
        Array[File] truth_vcfs
        Float background_fold_coverage
        Float background_samplerate
        Float host_fold_coverage
        Float host_samplerate
    }

    command <<<
        set -euxo
        name="~{sep=' ' sars_strain_names}" 
        fold="~{sep=' ' sars_fold_coverage}"
        rate="~{sep=' ' sars_samplerate}"
        vcfs="~{sep=' ' truth_vcfs}"

        arr_name=("$name")
        arr_fold=("$fold")
        arr_rate=("$rate")
        arr_vcfs=("$vcfs")

        echo "sample,strain,fold_coverage,samplerate,truth_vcf" > truth_~{sample_id}.csv
        for i in "${!arr_name[@]}"; do
           echo "~{sample_id},${arr_name[$i]},${arr_fold[$i]},${arr_rate[$i]},${arr_vcfs[$i]}" >> truth_~{sample_id}.csv
        done

        #echo "sample,organism,fold_coverage,samplerate" >> truth_~{sample_id}.csv
        echo "~{sample_id},background,~{background_fold_coverage},~{background_samplerate}" >> truth_~{sample_id}.csv
        echo "~{sample_id},host,~{host_fold_coverage},~{host_samplerate}" >> truth_~{sample_id}.csv
    >>>

    output {
        File truth_csv = "truth_~{sample_id}.csv"
    }

    runtime {
        docker: "ubuntu:25.04"
        cpu: 1
        memory: "1G"
    }
}

task combine_truth_metadata {
    input {
        Array[File] truth_csvs
    }

    command <<<
        set -euxo
        head -n 1 ~{truth_csvs[0]} > truth_manifest.csv
        for f in ~{sep=' ' truth_csvs}; do
        tail -n +2 $f >> truth_manifest.csv
        done
    >>>

    output {
        File truth_manifest = "truth_manifest.csv"
    }

    runtime {
        docker: "ubuntu:25.04"
        cpu: 1
        memory: "1G"
    }
}

task fragment_reference {
    input {
        File reference_fasta
        Int frag_mean
        Int frag_sd
        String prefix
    }

    command <<<
        set -euxo
        seqkit sliding -s 50 -W ~{frag_mean} ~{reference_fasta} \
        | seqkit shuffle > ~{prefix}.fragmented.fasta
    >>>

    output {
        File fragmented_fasta = "~{prefix}.fragmented.fasta"
    }

    runtime {
        docker: "dbest/seqkit:v2.10.1"
        cpu: 1
        memory: "2G"
    }
}

task mask_primer_tiles {
    input {
        File reference_fasta
        File primer_bed
        Array[Int] dropout_tiles
        String prefix
    }

    command <<<
        set -euxo
        cp ~{reference_fasta} masked.fasta
        if [[ ~{length(dropout_tiles)} -gt 0 ]]; then
           for tile in ~{sep=' ' dropout_tiles}; do
              awk -v t=$tile '$4 ~ t {print $1"\t"$2"\t"$3}' ~{primer_bed} >> ~{prefix}.dropout.bed
           done
           bedtools maskfasta -fi masked.fasta -bed ~{prefix}.dropout.bed -fo ~{prefix}.masked.fasta
        else
          cp ~{reference_fasta} ~{prefix}.masked.fasta
          touch ~{prefix}.dropout.bed
        fi
    >>>

    output {
        File masked_fasta = "~{prefix}.masked.fasta"
        File dropout_bed = "~{prefix}.dropout.bed"
    }

    runtime {
        docker: "staphb/bedtools:2.31.1"
        cpu: 1
        memory: "2G"
    }
}

task call_truth_variants {
    input {
        File baseline_fasta
        File bam
        String strain_name
    }

    command <<<
        set -euxo
        bcftools mpileup -f ~{baseline_fasta} ~{bam} \
        | bcftools call -mv -Oz -o ~{strain_name}.truth.vcf.gz

        bcftools index ~{strain_name}.truth.vcf.gz
    >>>

    output {
        File truth_vcf = "~{strain_name}.truth.vcf.gz"
        File truth_vcf_index = "~{strain_name}.truth.vcf.gz.csi"
    }

    runtime {
        docker: "dbest/samtools:v1.23"
        cpu: 1
        memory: "2G"
    }
}

task merge_truth_vcfs {
    input {
        Array[File] truth_vcfs
        Array[File] truth_vcfs_index
        String sample_id
    }

    command <<<
        set -euxo
        bcftools merge ~{sep=' ' truth_vcfs} --force-single -m all -Oz -o ~{sample_id}.truth_merged.vcf.gz
        bcftools index ~{sample_id}.truth_merged.vcf.gz
    >>>

    output {
        File merged_truth_vcf = "~{sample_id}.truth_merged.vcf.gz"
        File merged_truth_vcf_index = "~{sample_id}.truth_merged.vcf.gz.csi"
    }

    runtime {
        docker: "dbest/samtools:v1.23"
        cpu: 1
        memory: "2G"
    }
}

task compute_coverage_holes {

    input {
        File baseline_fasta
        File dropout_bed
        String sample_name
        String prefix
    }

    command <<<
        set -euxo pipefail

        GENOME_SIZE=$(grep -v ">" ~{baseline_fasta} | tr -d '\n' | wc -c)

        cat ~{dropout_bed} | sort -k1,1 -k2,2n > ~{prefix}.holes.bed
        NUM_HOLES=$(wc -l < ~{prefix}.holes.bed)
        TOTAL_BP=$(awk '{sum += $3-$2} END {print sum}' ~{prefix}.holes.bed)

        HOLE_FRAC=$(awk -v h="$TOTAL_BP" -v g="$GENOME_SIZE" 'BEGIN {print h / g}')

        cat <<EOF > ~{prefix}.coverage_hole_metrics.json
        {
            "sample": "~{sample_name}",
            "num_coverage_holes": $NUM_HOLES,
            "total_hole_bp": $TOTAL_BP,
            "hole_fraction": $HOLE_FRAC
        }
        EOF

    >>>

    output {
        File hole_regions = "~{prefix}.holes.bed"
        File hole_metrics_json = "~{prefix}.coverage_hole_metrics.json"
    }

    runtime {
        docker: "ubuntu:25.04"
        cpu: 1
        memory: "2G"
    }
}

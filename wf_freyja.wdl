version 1.0

task freyja_variants_task {
  input {
    File bam_file
    String docker_image
    File ref_fasta
    String? variants_output_path
    String? depths_output_path
    String? ref_name
    Int? min_base_quality
    File? annotation_gff
    Float? variant_frequency_threshold
  }

  command <<<
    freyja variants \
    ~{bam_file} \
    --ref ~{ref_fasta} \
    ~{true=' --variants ' false="" defined(variants_output_path)} ~{variants_output_path} \
    ~{true=' --depths '  false="" defined(depths_output_path)} ~{depths_output_path} \
    ~{true=' --refname '  false="" defined(ref_name)} ~{ref_name} \
    ~{true=' --minq '  false="" defined(min_base_quality)}  ~{ref_name}\
    ~{true=' --annot '  false="" defined(annotation_gff)}  ~{ref_name} \
    ~{true=' --varthresh '  false="" defined(variant_frequency_threshold)} ~{ref_name}
  >>>

  output {
    File variants = select_first([variants_output_path, stdout()])
    File depths = select_first([depths_output_path, stdout()])
  }

  runtime {
    docker: docker_image
  }
}

task freyja_demix_task {
  input {
    File variants_file
    File depths_file
    String docker_image
    Float? minimum_abundance
    File? barcode_file
    File? metadata_file
    String? output_file
    Int? coverage_cutoff
    Boolean? confirmed_only
    Int? depth_cutoff
    File? lineage_yaml
    Float? adaptive_lasso_penalty
    Float? adaptive_lasso_threshold
    String? region_of_interest_json
    Boolean? relaxed_mrca
    Float? relaxed_threshold
    String? solver_type
    String? pathogen_of_interest
  }

  command <<<
    freyja demix \
    ~{variants_file} \
    ~{depths_file} \
    ~{true='--eps' false="" defined(minimum_abundance)} ~{minimum_abundance} \
    ~{true='--barcodes' false="" defined(barcode_file)} ~{barcode_file} \
    ~{true='--meta' false="" defined(metadata_file)} ~{metadata_file} \
    ~{true='--output' false="" defined(output_file)} ~{output_file} \
    ~{true='--covcut' false="" defined(coverage_cutoff)} ~{coverage_cutoff} \
    ~{true='--confirmedonly' false='' confirmed_only} \
    ~{true='--depthcutoff' false="" defined(depth_cutoff)} ~{depth_cutoff} \
    ~{true='--lineageyml' false="" defined(lineage_yaml)} ~{lineage_yaml} \
    ~{true='--adapt' false="" defined(adaptive_lasso_penalty)} ~{adaptive_lasso_penalty} \
    ~{true='--a_eps' false="" defined(adaptive_lasso_threshold)} ~{adaptive_lasso_threshold} \
    ~{true='--region_of_interest' false="" defined(region_of_interest_json)} ~{region_of_interest_json} \
    ~{true='--relaxedmrca' false='' defined(relaxed_mrca)} ~{relaxed_mrca} \
    ~{true='--relaxedthresh' false="" defined(relaxed_threshold)} ~{relaxed_threshold} \
    ~{true='--solver' false="" defined(solver_type)} ~{solver_type} \
    ~{true='--pathogen' false="" defined(pathogen_of_interest)} ~{pathogen_of_interest} 
  >>>

  output {
    File demixing_result = select_first([output_file, "demixing_result.tsv"])
  }

  runtime {
    docker: docker_image
  }
}

workflow freyja_workflow {
  input {
    File input_bam_file
    String freyja_docker_image
    File reference_fasta
    String variants_file
    String depths_file
    String? reference_genome_name
    Int? minimum_quality_score
    File? annotation_file
    Float? variant_threshold
    Float? demix_minimum_abundance
    File? demix_barcode_file
    File? demix_metadata_file
    String? demix_output_file
    Int? demix_coverage_cutoff
    Boolean? demix_confirmed_only
    Int? demix_depth_cutoff
    File? demix_lineage_yaml
    Float? demix_adaptive_lasso_penalty
    Float? demix_adaptive_lasso_threshold
    String? demix_region_of_interest_json
    Boolean? demix_relaxed_mrca
    Float? demix_relaxed_threshold
    String? demix_solver_type
    String? demix_pathogen_of_interest
  }

  call freyja_variants_task {
    input:
    bam_file = input_bam_file,
    docker_image = freyja_docker_image,
    ref_fasta = reference_fasta,
    variants_output_path = variants_file,
    depths_output_path = depths_file,
    ref_name = reference_genome_name,
    min_base_quality = minimum_quality_score,
    annotation_gff = annotation_file,
    variant_frequency_threshold = variant_threshold
  }

  call freyja_demix_task {
    input:
    variants_file = freyja_variants_task.variants,
    depths_file = freyja_variants_task.depths,
    docker_image = freyja_docker_image,
    minimum_abundance = demix_minimum_abundance,
    barcode_file = demix_barcode_file,
    metadata_file = demix_metadata_file,
    output_file = demix_output_file,
    coverage_cutoff = demix_coverage_cutoff,
    confirmed_only = demix_confirmed_only,
    depth_cutoff = demix_depth_cutoff,
    lineage_yaml = demix_lineage_yaml,
    adaptive_lasso_penalty = demix_adaptive_lasso_penalty,
    adaptive_lasso_threshold = demix_adaptive_lasso_threshold,
    region_of_interest_json = demix_region_of_interest_json,
    relaxed_mrca = demix_relaxed_mrca,
    relaxed_threshold = demix_relaxed_threshold,
    solver_type = demix_solver_type,
    pathogen_of_interest = demix_pathogen_of_interest
  }

  output {
    File variants_output = freyja_variants_task.variants
    File depths_output = freyja_variants_task.depths
    File lineage_abundances = freyja_demix_task.demixing_result
  }
}

version 1.0

task task_freyja {
  input {
    Int depth_cut_off = 0
    Int min_base_quality = 0
    String samplename
    String pathogen
    String docker = "dbest/freyja:v2.0.1"
    Int disk_size = 100
    String memory
    File reference
    File bam
    File bai
  }
  
  command <<<
    set -euxo pipefail
    git clone https://github.com/andersen-lab/Freyja-barcodes.git
    freyja variants ~{bam} --variants ~{samplename}.tsv --depths ~{samplename}.depth --minq ~{min_base_quality} --ref ~{reference}
    if [ ~{pathogen} == "SARS-CoV-2" ] ; then
       freyja update --pathogen ~{pathogen}
       freyja demix ~{samplename}.tsv ~{samplename}.depth --output ~{samplename}.demixed.tsv --depthcutoff ~{depth_cut_off} --autoadapt
       #--adapt 0.035
    else
       mkdir -p ~{pathogen}
       freyja update --pathogen ~{pathogen} --outdir ~{pathogen}
       BARCODES=$(find ~{pathogen} -name "*.csv")
       LINEAGES=$(find ~{pathogen} -name "*.yml")
       freyja demix ~{samplename}.tsv ~{samplename}.depth --output ~{samplename}.demixed.tsv --pathogen ~{pathogen} --lineageyml ${LINEAGES} --barcodes ${BARCODES} --depthcutoff ~{depth_cut_off} --autoadapt
       #--adapt 0.035
    fi
  >>>
    
  output {
    File variants = samplename+ ".tsv"
    File depths = samplename + ".depth"
    File demixing_output = samplename + ".demixed.tsv"
  }
  
  runtime {
    docker: docker
    memory: memory
    cpu: 1
    disks: "local-disk " + disk_size + " SSD"
  }
}  

/**
 * WDL Task to run the 'freyja aggregate' command.
 * Aggregates demix data contained within a results directory into a single TSV file.
 */
task aggregate {
    input {
        // The directory containing the demix result files (e.g., .demix.tsv files).
        Directory results_directory

        // Optional file extension to filter the files in the results directory.
        // If not provided, freyja will use its default search pattern.
        String? file_extension

        // The name of the resulting aggregated output file.
        // Matches the tool's default if not specified.
        String output_filename = "aggregated_result.tsv"

        // Runtime setting: Using a public biocontainer image that includes freyja.
        String docker = "dbest/freyja:v2.0.1"
    }

    command <<<
        set -euxo
        freyja aggregate \
            ~{if defined(file_extension) then "--ext " + file_extension else ""} \
            --output ~{output_filename} \
            ~{results_directory}
    >>>

    output {
        File aggregated_results = "~{output_filename}"
    }

    runtime {
        docker: docker
        cpu: 2
        memory: "4 GB"
        disk: "10 GB"
    }
}

/**
 * WDL Task to run the 'freyja demix' command.
 * Generates relative lineage abundances from variant and depth counts.
 */
task demix {
    input {
        // --- Required Inputs ---
        File variants_file // VARIANTS file (e.g., from freyja variants)
        File depths_file   // DEPTHS file (e.g., from freyja variants)

        // --- Output & Core Parameters ---
        String output_filename = "demixing_result.tsv"
        String pathogen = "SARS-CoV-2" // Pathogen of interest. Not used if using --barcodes.

        // --- Optional Files ---
        File? barcodes_file       // Path to custom barcode file
        File? meta_file           // Custom lineage to variant metadata file
        File? lineage_yml         // Lineage hierarchy file in a yaml format
        File? region_of_interest  // JSON file containing region(s) of interest

        // --- Abundance & Quality Control ---
        Float eps = 0.001           // Minimum abundance to include for each lineage
        Int covcut = 10             // Calculate percent of sites with n or greater reads
        Int depth_cutoff = 0        // Exclude sites with coverage depth below this value
        Boolean confirmed_only = false // Exclude unconfirmed lineages

        // --- Solver & Regularization Parameters ---
        Float adapt = 0.0           // Adaptive lasso penalty parameter (0.0 for standard lasso)
        Float a_eps = 1e-08         // Adaptive lasso parameter, hard threshold
        Boolean auto_adapt = false  // Use error profile to set adapt
        String solver = "CLARABEL"  // Solver used for estimating lineage prevalence
        Int max_solver_threads = 1  // Max threads for multithreaded solvers (0 for auto)
        Boolean verbose_solver = false // Enable solver verbosity

        // --- Relaxed MRCA Parameters (used with depth_cutoff > 0) ---
        Boolean relaxed_mrca = false  // Clusters are assigned robust mrca
        Float relaxed_thresh = 0.9    // Associated threshold for robust mrca function

        // --- Runtime Configuration ---
        String docker = "dbest/freyja:v2.0.1"
    }

    command <<<
        set -euxo
        
        # Build the command, conditionally including optional files and boolean flags
        freyja demix \
            --output ~{output_filename} \
            --pathogen ~{pathogen} \
            --eps ~{eps} \
            --covcut ~{covcut} \
            --depthcutoff ~{depth_cutoff} \
            --adapt ~{adapt} \
            --a_eps ~{a_eps} \
            --solver ~{solver} \
            --max-solver-threads ~{max_solver_threads} \
            --relaxedthresh ~{relaxed_thresh} \
            
            # Optional file inputs
            ~{if defined(barcodes_file) then "--barcodes " + barcodes_file else ""} \
            ~{if defined(meta_file) then "--meta " + meta_file else ""} \
            ~{if defined(lineage_yml) then "--lineageyml " + lineage_yml else ""} \
            ~{if defined(region_of_interest) then "--region_of_interest " + region_of_interest else ""} \
            
            # Boolean flags
            ~{if confirmed_only then "--confirmedonly" else ""} \
            ~{if auto_adapt then "--autoadapt" else ""} \
            ~{if relaxed_mrca then "--relaxedmrca" else ""} \
            ~{if verbose_solver then "--verbose-solver" else ""} \
            
            # Positional arguments
            ~{variants_file} \
            ~{depths_file}
            
    >>>

    output {
        // The file containing the relative lineage abundances.
        File demixing_results = "~{output_filename}"
    }

    runtime {
        docker: docker
        cpu: 4
        memory: "16 GB"
        disk: "20 GB"
    }
}

/**
 * WDL Task to run the 'freyja variants' command.
 * Performs variant calling and depth calculation using samtools and iVar on an aligned BAM file.
 */
task variants {
    input {
        // --- Required Inputs ---
        File bam_file            // Positional argument: The aligned BAM file.
        File reference_fasta     // The reference genome FASTA file (--ref).

        // --- Output & Core Parameters ---
        String variants_output_name = "variants.tsv" // Output filename for variant calls (--variants).
        String depths_output_name = "depths.tsv"     // Output filename for sequencing depth (--depths).
        Int min_base_quality = 20                // Minimum base quality score (--minq).
        Float variant_frequency_threshold = 0.0  // Variant frequency threshold (--varthresh).

        // --- Optional Inputs ---
        String? ref_name                 // Ref name for bams with multiple sequences (--refname).
        File? annotation_gff3            // Annotation file in gff3 format (--annot).

        // --- Runtime Configuration ---
        String docker = "dbest/freyja:v2.0.1"
    }

    command <<<
        set -euxo
        freyja variants \
            --ref ~{reference_fasta} \
            --variants ~{variants_output_name} \
            --depths ~{depths_output_name} \
            --minq ~{min_base_quality} \
            --varthresh ~{variant_frequency_threshold} \
            
            # Optional inputs
            ~{if defined(ref_name) then "--refname " + ref_name else ""} \
            ~{if defined(annotation_gff3) then "--annot " + annotation_gff3 else ""} \
            
            # Positional argument
            ~{bam_file}
            
    >>>

    output {
        // Output file containing variant calls.
        File variant_calls = "~{variants_output_name}"
        
        // Output file containing sequencing depth information.
        File depth_counts = "~{depths_output_name}"
    }

    runtime {
        docker: docker
        cpu: 8
        memory: "32 GB"
        disk: "50 GB" 
    }
}

/**
 * WDL Task to run the 'freyja boot' command.
 * Performs bootstrapping to estimate confidence intervals for lineage abundances.
 */
task boot {
    input {
        // --- Required Inputs (Positional Arguments) ---
        File variants_file // VARIANTS file (output of freyja variants).
        File depths_file   // DEPTHS file (output of freyja variants).

        // --- Output & Core Parameters ---
        String output_base_name = "test" // Output file basename (--output_base).
        String pathogen = "SARS-CoV-2"  // Pathogen of interest.

        // --- Bootstrapping Parameters ---
        Int num_bootstraps = 100       // Number of times bootstrapping is performed (--nb).
        Int boot_seed = 0              // Set seed for bootstrap generation (--bootseed).
        
        // --- Solver & Demixing Parameters ---
        Int max_threads = 1            // Max number of CPUs to use for parallel execution (--nt).
        Float eps = 0.001              // Minimum abundance to include (--eps).
        Int depth_cutoff = 0           // Exclude sites with coverage depth below this value (--depthcutoff).
        String solver = "CLARABEL"     // Solver used for estimating lineage prevalence (--solver).
        
        // --- Optional Files and Formats ---
        File? barcodes_file            // Custom barcode file (--barcodes).
        File? meta_file                // Custom lineage to variant metadata file (--meta).
        File? lineage_yml              // Lineage hierarchy file in yaml format (--lineageyml).
        String? boxplot_format         // File format of boxplot output (e.g., "pdf" or "png") (--boxplot).

        // --- Flags ---
        Boolean confirmed_only = false // Exclude unconfirmed lineages (--confirmedonly).
        Boolean raw_bootstraps = false // Return raw bootstraps (--rawboots).
        Boolean relaxed_mrca = false   // Use robust MRCA for clusters with depth cutoff (--relaxedmrca).
        Float relaxed_thresh = 0.9     // Associated threshold for robust MRCA function (--relaxedthresh).
        Boolean auto_adapt = false     // Use error profile to set adapt (--autoadapt).

        // --- Runtime Configuration ---
        String docker_image = "dbest/freyja:v2.0.1"
    }

    command <<<
        set -euxo

        # Set the number of threads for the runtime environment to match the command flag
        # NOTE: This ensures the task respects the runtime settings.
        export NUM_THREADS=~{max_threads} 

        # Build the command, conditionally including optional files and flags.
        freyja boot \
            --nb ~{num_bootstraps} \
            --nt ~{max_threads} \
            --eps ~{eps} \
            --output_base ~{output_base_name} \
            --depthcutoff ~{depth_cutoff} \
            --relaxedthresh ~{relaxed_thresh} \
            --bootseed ~{boot_seed} \
            --solver ~{solver} \
            --pathogen ~{pathogen} \

            # Optional files and formats
            ~{if defined(barcodes_file) then "--barcodes " + barcodes_file else ""} \
            ~{if defined(meta_file) then "--meta " + meta_file else ""} \
            ~{if defined(lineage_yml) then "--lineageyml " + lineage_yml else ""} \
            ~{if defined(boxplot_format) then "--boxplot " + boxplot_format else ""} \

            # Boolean flags
            ~{if confirmed_only then "--confirmedonly" else ""} \
            ~{if raw_bootstraps then "--rawboots" else ""} \
            ~{if relaxed_mrca then "--relaxedmrca" else ""} \
            ~{if auto_adapt then "--autoadapt" else ""} \

            # Positional arguments
            ~{variants_file} \
            ~{depths_file}
            
    >>>

    output {
        // Main output file containing the aggregated bootstrap results (e.g., test_bootstraps.tsv).
        File bootstrap_summary = "~{output_base_name}_bootstraps.tsv"
        
        // Optional raw bootstrap results (if --rawboots is used).
        File? raw_bootstraps_output = if (raw_bootstraps) then "~{output_base_name}.boot.json" else null
        
        // Optional boxplot image (if --boxplot format is specified).
        File? boxplot_image = if (defined(boxplot_format)) then "~{output_base_name}_boxplot.~{boxplot_format}" else null
    }

    runtime {
        docker: docker_image
        cpu: max_threads
        memory: "16 GB"
        disk: "10 GB"
    }
}

/**
 * WDL Task to run the 'freyja update' command.
 * Downloads and updates the local repository of barcodes and curated lineage data.
 */
task update {
    input {
        // --- Core Parameters ---
        String pathogen = "SARS-CoV-2"  // Pathogen to provide update for (--pathogen).
        
        // --- Output ---
        // The output directory where the updated barcode and lineage files will be saved.
        String output_directory = "updated_freyja_data" // Output directory (--outdir).
        
        // --- Flags ---
        // Note: The description for --noncl is ambiguous in the tool's help text. 
        // This input models the presence of the --noncl flag.
        Boolean noncl_flag = false       // Includes the --noncl flag if true.
        Boolean build_locally = false    // Perform barcode building locally (--buildlocal).

        // --- Runtime Configuration ---
        String docker_image = "dbest/freyja:v2.0.1"
    }

    command <<<
        set -euxo

        freyja update \
            --outdir ~{output_directory} \
            --pathogen ~{pathogen} \
            
            # Boolean flags
            ~{if noncl_flag then "--noncl" else ""} \
            ~{if build_locally then "--buildlocal" else ""}
            
    >>>

    output {
        // Return the directory containing the updated barcodes and curated lineage data.
        // This directory can then be passed to other freyja tasks (like demix).
        Directory updated_data_dir = "~{output_directory}"
    }

    runtime {
        docker: docker_image
        cpu: 1
        memory: "4 GB"
        disk: "10 GB" 
    }
}

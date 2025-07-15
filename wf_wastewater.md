# wastewater


## Inputs

### Required inputs
<p name="wastewater.docker_fastp">
        <b>wastewater.docker_fastp</b><br />
        <i>String &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.docker_fastqc">
        <b>wastewater.docker_fastqc</b><br />
        <i>String &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.docker_freyja">
        <b>wastewater.docker_freyja</b><br />
        <i>String &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.docker_minimap2">
        <b>wastewater.docker_minimap2</b><br />
        <i>String &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.docker_multiqc">
        <b>wastewater.docker_multiqc</b><br />
        <i>String &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.read1">
        <b>wastewater.read1</b><br />
        <i>File &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.read2">
        <b>wastewater.read2</b><br />
        <i>File &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.reference">
        <b>wastewater.reference</b><br />
        <i>File &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.samplename">
        <b>wastewater.samplename</b><br />
        <i>String &mdash; Default: None</i><br />
        ???
</p>

### Other common inputs
<p name="wastewater.wf_minimap2.Mapping.howToFindGTAG">
        <b>wastewater.wf_minimap2.Mapping.howToFindGTAG</b><br />
        <i>String? &mdash; Default: None</i><br />
        How to find GT-AG. f:transcript strand, b:both strands, n:don't match GT-AG.
</p>

### Advanced inputs
<details>
<summary> Show/Hide </summary>
<p name="wastewater.task_fastqc.memory">
        <b>wastewater.task_fastqc.memory</b><br />
        <i>String &mdash; Default: "8GB"</i><br />
        The amount of memory this job will use.
</p>
<p name="wastewater.wf_minimap2.Indexing.kmerSize">
        <b>wastewater.wf_minimap2.Indexing.kmerSize</b><br />
        <i>Int &mdash; Default: 15</i><br />
        K-mer size (no larger than 28).
</p>
<p name="wastewater.wf_minimap2.Indexing.memory">
        <b>wastewater.wf_minimap2.Indexing.memory</b><br />
        <i>String &mdash; Default: "4G"</i><br />
        The amount of memory available to the job.
</p>
<p name="wastewater.wf_minimap2.Indexing.minimizerWindowSize">
        <b>wastewater.wf_minimap2.Indexing.minimizerWindowSize</b><br />
        <i>Int &mdash; Default: 10</i><br />
        Minimizer window size.
</p>
<p name="wastewater.wf_minimap2.Indexing.splitIndex">
        <b>wastewater.wf_minimap2.Indexing.splitIndex</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Split index for every ~NUM input bases.
</p>
<p name="wastewater.wf_minimap2.Indexing.timeMinutes">
        <b>wastewater.wf_minimap2.Indexing.timeMinutes</b><br />
        <i>Int &mdash; Default: 10</i><br />
        The maximum amount of time the job will run in minutes.
</p>
<p name="wastewater.wf_minimap2.Indexing.useHomopolymerCompressedKmer">
        <b>wastewater.wf_minimap2.Indexing.useHomopolymerCompressedKmer</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Use homopolymer-compressed k-mer (preferrable for pacbio).
</p>
<p name="wastewater.wf_minimap2.Mapping.kmerSize">
        <b>wastewater.wf_minimap2.Mapping.kmerSize</b><br />
        <i>Int &mdash; Default: 15</i><br />
        K-mer size (no larger than 28).
</p>
<p name="wastewater.wf_minimap2.Mapping.matchingScore">
        <b>wastewater.wf_minimap2.Mapping.matchingScore</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Matching score.
</p>
<p name="wastewater.wf_minimap2.Mapping.maxFragmentLength">
        <b>wastewater.wf_minimap2.Mapping.maxFragmentLength</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Max fragment length (effective with -xsr or in the fragment mode).
</p>
<p name="wastewater.wf_minimap2.Mapping.maxIntronLength">
        <b>wastewater.wf_minimap2.Mapping.maxIntronLength</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Max intron length (effective with -xsplice; changing -r).
</p>
<p name="wastewater.wf_minimap2.Mapping.memory">
        <b>wastewater.wf_minimap2.Mapping.memory</b><br />
        <i>String &mdash; Default: "30G"</i><br />
        The amount of memory available to the job.
</p>
<p name="wastewater.wf_minimap2.Mapping.mismatchPenalty">
        <b>wastewater.wf_minimap2.Mapping.mismatchPenalty</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Mismatch penalty.
</p>
<p name="wastewater.wf_minimap2.Mapping.retainMaxSecondaryAlignments">
        <b>wastewater.wf_minimap2.Mapping.retainMaxSecondaryAlignments</b><br />
        <i>Int? &mdash; Default: None</i><br />
        Retain at most N secondary alignments.
</p>
<p name="wastewater.wf_minimap2.Mapping.secondaryAlignment">
        <b>wastewater.wf_minimap2.Mapping.secondaryAlignment</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Whether to output secondary alignments.
</p>
<p name="wastewater.wf_minimap2.Mapping.skipSelfAndDualMappings">
        <b>wastewater.wf_minimap2.Mapping.skipSelfAndDualMappings</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        Skip self and dual mappings (for the all-vs-all mode).
</p>
<p name="wastewater.wf_minimap2.Mapping.timeMinutes">
        <b>wastewater.wf_minimap2.Mapping.timeMinutes</b><br />
        <i>Int &mdash; Default: 1 + ceil((size(queryFile1,"G") * 200 / cores))</i><br />
        The maximum amount of time the job will run in minutes.
</p>
</details>

### Other inputs
<details>
<summary> Show/Hide </summary>
<p name="wastewater.freyja_workflow.annotation_file">
        <b>wastewater.freyja_workflow.annotation_file</b><br />
        <i>File? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_adaptive_lasso_penalty">
        <b>wastewater.freyja_workflow.demix_adaptive_lasso_penalty</b><br />
        <i>Float? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_adaptive_lasso_threshold">
        <b>wastewater.freyja_workflow.demix_adaptive_lasso_threshold</b><br />
        <i>Float? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_barcode_file">
        <b>wastewater.freyja_workflow.demix_barcode_file</b><br />
        <i>File? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_confirmed_only">
        <b>wastewater.freyja_workflow.demix_confirmed_only</b><br />
        <i>Boolean? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_coverage_cutoff">
        <b>wastewater.freyja_workflow.demix_coverage_cutoff</b><br />
        <i>Int? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_depth_cutoff">
        <b>wastewater.freyja_workflow.demix_depth_cutoff</b><br />
        <i>Int? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_lineage_yaml">
        <b>wastewater.freyja_workflow.demix_lineage_yaml</b><br />
        <i>File? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_metadata_file">
        <b>wastewater.freyja_workflow.demix_metadata_file</b><br />
        <i>File? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_minimum_abundance">
        <b>wastewater.freyja_workflow.demix_minimum_abundance</b><br />
        <i>Float? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_output_file">
        <b>wastewater.freyja_workflow.demix_output_file</b><br />
        <i>String? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_pathogen_of_interest">
        <b>wastewater.freyja_workflow.demix_pathogen_of_interest</b><br />
        <i>String? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_region_of_interest_json">
        <b>wastewater.freyja_workflow.demix_region_of_interest_json</b><br />
        <i>String? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_relaxed_mrca">
        <b>wastewater.freyja_workflow.demix_relaxed_mrca</b><br />
        <i>Boolean? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_relaxed_threshold">
        <b>wastewater.freyja_workflow.demix_relaxed_threshold</b><br />
        <i>Float? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.demix_solver_type">
        <b>wastewater.freyja_workflow.demix_solver_type</b><br />
        <i>String? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.minimum_quality_score">
        <b>wastewater.freyja_workflow.minimum_quality_score</b><br />
        <i>Int? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.reference_genome_name">
        <b>wastewater.freyja_workflow.reference_genome_name</b><br />
        <i>String? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.freyja_workflow.variant_threshold">
        <b>wastewater.freyja_workflow.variant_threshold</b><br />
        <i>Float? &mdash; Default: None</i><br />
        ???
</p>
<p name="wastewater.task_fastp.adapter_sequence">
        <b>wastewater.task_fastp.adapter_sequence</b><br />
        <i>String &mdash; Default: "AGATCGGAAGAGCACACGTC"</i><br />
        ???
</p>
<p name="wastewater.task_fastp.adapter_sequence_r2">
        <b>wastewater.task_fastp.adapter_sequence_r2</b><br />
        <i>String &mdash; Default: "AGATCGGAAGAGCGTCGTGTAGGAAAGAGTG"</i><br />
        ???
</p>
<p name="wastewater.task_fastp.complexity_threshold">
        <b>wastewater.task_fastp.complexity_threshold</b><br />
        <i>Int &mdash; Default: 40</i><br />
        ???
</p>
<p name="wastewater.task_fastp.correction">
        <b>wastewater.task_fastp.correction</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        ???
</p>
<p name="wastewater.task_fastp.cutadapt_compatible">
        <b>wastewater.task_fastp.cutadapt_compatible</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        ???
</p>
<p name="wastewater.task_fastp.disable_quality_filtering">
        <b>wastewater.task_fastp.disable_quality_filtering</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        ???
</p>
<p name="wastewater.task_fastp.extra_options">
        <b>wastewater.task_fastp.extra_options</b><br />
        <i>String &mdash; Default: ""</i><br />
        ???
</p>
<p name="wastewater.task_fastp.filter_by_index">
        <b>wastewater.task_fastp.filter_by_index</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        ???
</p>
<p name="wastewater.task_fastp.low_complexity_filter">
        <b>wastewater.task_fastp.low_complexity_filter</b><br />
        <i>Int &mdash; Default: 0</i><br />
        ???
</p>
<p name="wastewater.task_fastp.merge_pe">
        <b>wastewater.task_fastp.merge_pe</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        ???
</p>
<p name="wastewater.task_fastp.n_base_limit">
        <b>wastewater.task_fastp.n_base_limit</b><br />
        <i>Int &mdash; Default: 5</i><br />
        ???
</p>
<p name="wastewater.task_fastp.outprefix">
        <b>wastewater.task_fastp.outprefix</b><br />
        <i>String &mdash; Default: sample_id</i><br />
        ???
</p>
<p name="wastewater.task_fastp.output_read1">
        <b>wastewater.task_fastp.output_read1</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        ???
</p>
<p name="wastewater.task_fastp.output_read2">
        <b>wastewater.task_fastp.output_read2</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        ???
</p>
<p name="wastewater.task_fastp.proper_pairs_only">
        <b>wastewater.task_fastp.proper_pairs_only</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        ???
</p>
<p name="wastewater.task_fastp.q">
        <b>wastewater.task_fastp.q</b><br />
        <i>Int &mdash; Default: 20</i><br />
        ???
</p>
<p name="wastewater.task_fastp.threads">
        <b>wastewater.task_fastp.threads</b><br />
        <i>Int &mdash; Default: 2</i><br />
        ???
</p>
<p name="wastewater.task_fastp.trim_front1">
        <b>wastewater.task_fastp.trim_front1</b><br />
        <i>Int &mdash; Default: 0</i><br />
        ???
</p>
<p name="wastewater.task_fastp.trim_front2">
        <b>wastewater.task_fastp.trim_front2</b><br />
        <i>Int &mdash; Default: 0</i><br />
        ???
</p>
<p name="wastewater.task_fastp.trim_tail1">
        <b>wastewater.task_fastp.trim_tail1</b><br />
        <i>Int &mdash; Default: 0</i><br />
        ???
</p>
<p name="wastewater.task_fastp.trim_tail2">
        <b>wastewater.task_fastp.trim_tail2</b><br />
        <i>Int &mdash; Default: 0</i><br />
        ???
</p>
<p name="wastewater.task_fastp.umi">
        <b>wastewater.task_fastp.umi</b><br />
        <i>Boolean &mdash; Default: false</i><br />
        ???
</p>
<p name="wastewater.task_fastp.umi_len">
        <b>wastewater.task_fastp.umi_len</b><br />
        <i>Int &mdash; Default: 0</i><br />
        ???
</p>
<p name="wastewater.task_fastp.umi_loc">
        <b>wastewater.task_fastp.umi_loc</b><br />
        <i>String &mdash; Default: "read1"</i><br />
        ???
</p>
<p name="wastewater.task_fastp.unqualified_percent_limit">
        <b>wastewater.task_fastp.unqualified_percent_limit</b><br />
        <i>Int &mdash; Default: 40</i><br />
        ???
</p>
<p name="wastewater.task_multiqc.docker">
        <b>wastewater.task_multiqc.docker</b><br />
        <i>String &mdash; Default: "multiqc/multiqc:v1.28"</i><br />
        ???
</p>
<p name="wastewater.task_multiqc.memory">
        <b>wastewater.task_multiqc.memory</b><br />
        <i>String &mdash; Default: "8GB"</i><br />
        ???
</p>
<p name="wastewater.threads">
        <b>wastewater.threads</b><br />
        <i>Int &mdash; Default: 1</i><br />
        ???
</p>
<p name="wastewater.wf_minimap2.Mapping.softClippingForSupplementaryAlignments">
        <b>wastewater.wf_minimap2.Mapping.softClippingForSupplementaryAlignments</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        ???
</p>
<p name="wastewater.wf_minimap2.Mapping.writeLongCigar">
        <b>wastewater.wf_minimap2.Mapping.writeLongCigar</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        ???
</p>
</details>

## Outputs
<p name="wastewater.abundances">
        <b>wastewater.abundances</b><br />
        <i>File</i><br />
        ???
</p>
<p name="wastewater.clean_reads1">
        <b>wastewater.clean_reads1</b><br />
        <i>File</i><br />
        ???
</p>
<p name="wastewater.clean_reads2">
        <b>wastewater.clean_reads2</b><br />
        <i>File</i><br />
        ???
</p>
<p name="wastewater.depths_output">
        <b>wastewater.depths_output</b><br />
        <i>File</i><br />
        ???
</p>
<p name="wastewater.forwardHtml">
        <b>wastewater.forwardHtml</b><br />
        <i>File</i><br />
        ???
</p>
<p name="wastewater.report">
        <b>wastewater.report</b><br />
        <i>File</i><br />
        ???
</p>
<p name="wastewater.reports_html">
        <b>wastewater.reports_html</b><br />
        <i>File</i><br />
        ???
</p>
<p name="wastewater.reports_json">
        <b>wastewater.reports_json</b><br />
        <i>File</i><br />
        ???
</p>
<p name="wastewater.reverseHtml">
        <b>wastewater.reverseHtml</b><br />
        <i>File</i><br />
        ???
</p>
<p name="wastewater.variants_output">
        <b>wastewater.variants_output</b><br />
        <i>File</i><br />
        ???
</p>

<hr />

> Generated using WDL AID (1.0.0)

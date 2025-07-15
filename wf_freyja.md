# freyja_workflow


## Inputs

### Required inputs
<p name="freyja_workflow.depths_file">
        <b>freyja_workflow.depths_file</b><br />
        <i>String &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.freyja_docker_image">
        <b>freyja_workflow.freyja_docker_image</b><br />
        <i>String &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.input_bam_file">
        <b>freyja_workflow.input_bam_file</b><br />
        <i>File &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.reference_fasta">
        <b>freyja_workflow.reference_fasta</b><br />
        <i>File &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.variants_file">
        <b>freyja_workflow.variants_file</b><br />
        <i>String &mdash; Default: None</i><br />
        ???
</p>

### Other inputs
<details>
<summary> Show/Hide </summary>
<p name="freyja_workflow.annotation_file">
        <b>freyja_workflow.annotation_file</b><br />
        <i>File? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_adaptive_lasso_penalty">
        <b>freyja_workflow.demix_adaptive_lasso_penalty</b><br />
        <i>Float? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_adaptive_lasso_threshold">
        <b>freyja_workflow.demix_adaptive_lasso_threshold</b><br />
        <i>Float? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_barcode_file">
        <b>freyja_workflow.demix_barcode_file</b><br />
        <i>File? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_confirmed_only">
        <b>freyja_workflow.demix_confirmed_only</b><br />
        <i>Boolean? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_coverage_cutoff">
        <b>freyja_workflow.demix_coverage_cutoff</b><br />
        <i>Int? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_depth_cutoff">
        <b>freyja_workflow.demix_depth_cutoff</b><br />
        <i>Int? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_lineage_yaml">
        <b>freyja_workflow.demix_lineage_yaml</b><br />
        <i>File? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_metadata_file">
        <b>freyja_workflow.demix_metadata_file</b><br />
        <i>File? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_minimum_abundance">
        <b>freyja_workflow.demix_minimum_abundance</b><br />
        <i>Float? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_output_file">
        <b>freyja_workflow.demix_output_file</b><br />
        <i>String? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_pathogen_of_interest">
        <b>freyja_workflow.demix_pathogen_of_interest</b><br />
        <i>String? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_region_of_interest_json">
        <b>freyja_workflow.demix_region_of_interest_json</b><br />
        <i>String? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_relaxed_mrca">
        <b>freyja_workflow.demix_relaxed_mrca</b><br />
        <i>Boolean? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_relaxed_threshold">
        <b>freyja_workflow.demix_relaxed_threshold</b><br />
        <i>Float? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.demix_solver_type">
        <b>freyja_workflow.demix_solver_type</b><br />
        <i>String? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.minimum_quality_score">
        <b>freyja_workflow.minimum_quality_score</b><br />
        <i>Int? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.reference_genome_name">
        <b>freyja_workflow.reference_genome_name</b><br />
        <i>String? &mdash; Default: None</i><br />
        ???
</p>
<p name="freyja_workflow.variant_threshold">
        <b>freyja_workflow.variant_threshold</b><br />
        <i>Float? &mdash; Default: None</i><br />
        ???
</p>
</details>

## Outputs
<p name="freyja_workflow.depths_output">
        <b>freyja_workflow.depths_output</b><br />
        <i>File</i><br />
        ???
</p>
<p name="freyja_workflow.lineage_abundances">
        <b>freyja_workflow.lineage_abundances</b><br />
        <i>File</i><br />
        ???
</p>
<p name="freyja_workflow.variants_output">
        <b>freyja_workflow.variants_output</b><br />
        <i>File</i><br />
        ???
</p>

<hr />

> Generated using WDL AID (1.0.0)

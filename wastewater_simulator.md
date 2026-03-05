# simulate_wastewater_multi_strain


## Inputs

### Required inputs
<p name="simulate_wastewater_multi_strain.background_fasta">
        <b>simulate_wastewater_multi_strain.background_fasta</b><br />
        <i>File &mdash; Default: None</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.background_fold_coverage">
        <b>simulate_wastewater_multi_strain.background_fold_coverage</b><br />
        <i>Array[Float] &mdash; Default: None</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.background_samplerate">
        <b>simulate_wastewater_multi_strain.background_samplerate</b><br />
        <i>Array[Float] &mdash; Default: None</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.dropout_tiles">
        <b>simulate_wastewater_multi_strain.dropout_tiles</b><br />
        <i>Array[Array[Int]] &mdash; Default: None</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.host_fold_coverage">
        <b>simulate_wastewater_multi_strain.host_fold_coverage</b><br />
        <i>Array[Float] &mdash; Default: None</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.host_samplerate">
        <b>simulate_wastewater_multi_strain.host_samplerate</b><br />
        <i>Array[Float] &mdash; Default: None</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.primer_bed">
        <b>simulate_wastewater_multi_strain.primer_bed</b><br />
        <i>File &mdash; Default: None</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.sample_ids">
        <b>simulate_wastewater_multi_strain.sample_ids</b><br />
        <i>Array[String] &mdash; Default: None</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.sars_baseline_fasta">
        <b>simulate_wastewater_multi_strain.sars_baseline_fasta</b><br />
        <i>File &mdash; Default: None</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.sars_fastas">
        <b>simulate_wastewater_multi_strain.sars_fastas</b><br />
        <i>Array[File] &mdash; Default: None</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.sars_fold_coverage_matrix">
        <b>simulate_wastewater_multi_strain.sars_fold_coverage_matrix</b><br />
        <i>Array[Array[Float]] &mdash; Default: None</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.sars_samplerate_matrix">
        <b>simulate_wastewater_multi_strain.sars_samplerate_matrix</b><br />
        <i>Array[Array[Float]] &mdash; Default: None</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.sars_strain_names">
        <b>simulate_wastewater_multi_strain.sars_strain_names</b><br />
        <i>Array[String] &mdash; Default: None</i><br />
        ???
</p>

### Other inputs
<details>
<summary> Show/Hide </summary>
<p name="simulate_wastewater_multi_strain.frag_mean">
        <b>simulate_wastewater_multi_strain.frag_mean</b><br />
        <i>Int &mdash; Default: 300</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.frag_sd">
        <b>simulate_wastewater_multi_strain.frag_sd</b><br />
        <i>Int &mdash; Default: 150</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.host_fasta">
        <b>simulate_wastewater_multi_strain.host_fasta</b><br />
        <i>File? &mdash; Default: None</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.illumina_platform">
        <b>simulate_wastewater_multi_strain.illumina_platform</b><br />
        <i>String &mdash; Default: "MSv3"</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.insert_sd">
        <b>simulate_wastewater_multi_strain.insert_sd</b><br />
        <i>Int &mdash; Default: 30</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.mean_insert">
        <b>simulate_wastewater_multi_strain.mean_insert</b><br />
        <i>Int &mdash; Default: 300</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.read_length">
        <b>simulate_wastewater_multi_strain.read_length</b><br />
        <i>Int &mdash; Default: 150</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.simulate_background.memory">
        <b>simulate_wastewater_multi_strain.simulate_background.memory</b><br />
        <i>String &mdash; Default: "10GB"</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.simulate_background.threads">
        <b>simulate_wastewater_multi_strain.simulate_background.threads</b><br />
        <i>Int &mdash; Default: 4</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.simulate_fragmentation">
        <b>simulate_wastewater_multi_strain.simulate_fragmentation</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.simulate_host.memory">
        <b>simulate_wastewater_multi_strain.simulate_host.memory</b><br />
        <i>String &mdash; Default: "10GB"</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.simulate_host.threads">
        <b>simulate_wastewater_multi_strain.simulate_host.threads</b><br />
        <i>Int &mdash; Default: 4</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.simulate_primer_dropout">
        <b>simulate_wastewater_multi_strain.simulate_primer_dropout</b><br />
        <i>Boolean &mdash; Default: true</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.simulate_sars.memory">
        <b>simulate_wastewater_multi_strain.simulate_sars.memory</b><br />
        <i>String &mdash; Default: "10GB"</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.simulate_sars.threads">
        <b>simulate_wastewater_multi_strain.simulate_sars.threads</b><br />
        <i>Int &mdash; Default: 4</i><br />
        ???
</p>
</details>

## Outputs
<p name="simulate_wastewater_multi_strain.combined_truth_manifest">
        <b>simulate_wastewater_multi_strain.combined_truth_manifest</b><br />
        <i>File</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.multiqc_report">
        <b>simulate_wastewater_multi_strain.multiqc_report</b><br />
        <i>File</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.truth_csvs">
        <b>simulate_wastewater_multi_strain.truth_csvs</b><br />
        <i>Array[File]</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.wastewater_R1">
        <b>simulate_wastewater_multi_strain.wastewater_R1</b><br />
        <i>Array[File]</i><br />
        ???
</p>
<p name="simulate_wastewater_multi_strain.wastewater_R2">
        <b>simulate_wastewater_multi_strain.wastewater_R2</b><br />
        <i>Array[File]</i><br />
        ???
</p>

<hr />

> Generated using WDL AID (1.0.0)

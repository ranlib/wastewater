#
# wastewater
#
wastewater:
	womtool validate --inputs wf_wastewater.json wf_wastewater.wdl
	miniwdl check wf_wastewater.wdl

wastewater_docu:
	wdl-aid wf_wastewater.wdl -o wf_wastewater.md
	womtool graph wf_wastewater.wdl > wf_wastewater.dot
	dot -Tpdf -o wf_wastewater.pdf wf_wastewater.dot
	dot -Tjpeg -o wf_wastewater.jpeg wf_wastewater.dot
	rm wf_wastewater.dot

run_wastewater:
	miniwdl run --debug --dir test-wastewater --cfg miniwdl_production.cfg --input wf_wastewater.json wf_wastewater.wdl

#
# wastewater_pathogen
#
wastewater_pathogen:
	womtool validate --inputs wf_wastewater_pathogen.json wf_wastewater_pathogen.wdl
	miniwdl check wf_wastewater_pathogen.wdl

wastewater_pathogen_docu:
	wdl-aid wf_wastewater_pathogen.wdl -o wf_wastewater_pathogen.md
	womtool graph wf_wastewater_pathogen.wdl > wf_wastewater_pathogen.dot
	dot -Tpdf -o wf_wastewater_pathogen.pdf wf_wastewater_pathogen.dot
	dot -Tjpeg -o wf_wastewater_pathogen.jpeg wf_wastewater_pathogen.dot
	rm wf_wastewater_pathogen.dot

run_wastewater_pathogen:
	miniwdl run --debug --dir test-wastewater_pathogen --cfg miniwdl_production.cfg --input wf_wastewater_pathogen.json wf_wastewater_pathogen.wdl

run_wastewater_pathogen_cromwell:
	cromwell run wf_wastewater_pathogen.wdl -i wf_wastewater_pathogen.json

run_wastewater_pathogen_measles:
	miniwdl run --debug --dir test-wastewater_pathogen_measles --cfg miniwdl_production.cfg --input wf_wastewater_pathogen_measles.json wf_wastewater_pathogen.wdl

run_wastewater_pathogen_measles_pure:
	miniwdl run --debug --dir test-wastewater_pathogen_measles_pure --cfg miniwdl_production.cfg --input wf_wastewater_pathogen_measles_pure.json wf_wastewater_pathogen.wdl

run_wastewater_pathogen_influenza:
	miniwdl run --debug --dir test-wastewater_pathogen_influenza --cfg miniwdl_production.cfg --input wf_wastewater_pathogen_influenza.json wf_wastewater_pathogen.wdl

#
# wastewater_pathogen
#
wastewater_influenza:
	womtool validate --inputs wf_wastewater_influenza.json wf_wastewater_influenza.wdl
	miniwdl check wf_wastewater_influenza.wdl

wastewater_influenza_docu:
	wdl-aid wf_wastewater_influenza.wdl -o wf_wastewater_influenza.md
	womtool graph wf_wastewater_influenza.wdl > wf_wastewater_influenza.dot
	dot -Tpdf -o wf_wastewater_influenza.pdf wf_wastewater_influenza.dot
	dot -Tjpeg -o wf_wastewater_influenza.jpeg wf_wastewater_influenza.dot
	rm wf_wastewater_influenza.dot

run_wastewater_influenza:
	miniwdl run --debug --dir test-wastewater_influenza --cfg miniwdl_production.cfg --input wf_wastewater_influenza.json wf_wastewater_influenza.wdl

#
# freyja
#
freyja:
	womtool validate --inputs wf_freyja.json wf_freyja.wdl
	miniwdl check wf_freyja.wdl

freyja_docu:
	wdl-aid wf_freyja.wdl -o wf_freyja.md
	womtool graph wf_freyja.wdl > wf_freyja.dot
	dot -Tpdf -o wf_freyja.pdf wf_freyja.dot
	dot -Tjpeg -o wf_freyja.jpeg wf_freyja.dot
	rm wf_freyja.dot

run_freyja:
	miniwdl run --debug --dir test-freyja --cfg miniwdl_production.cfg --input wf_freyja.json wf_freyja.wdl


#
# trim_galore
#
trim_galore:
	womtool validate --inputs wf_trim_galore.json wf_trim_galore.wdl
	miniwdl check wf_trim_galore.wdl

trim_galore_docu:
	wdl-aid wf_trim_galore.wdl -o wf_trim_galore.md
	womtool graph wf_trim_galore.wdl > wf_trim_galore.dot
	dot -Tpdf -o wf_trim_galore.pdf wf_trim_galore.dot
	dot -Tjpeg -o wf_trim_galore.jpeg wf_trim_galore.dot
	rm wf_trim_galore.dot

run_trim_galore:
	miniwdl run --debug --dir test-trim_galore --cfg miniwdl_production.cfg --input wf_trim_galore.json wf_trim_galore.wdl


#
# fastp
#
fastp:
	womtool validate --inputs wf_fastp.json wf_fastp.wdl
	miniwdl check wf_fastp.wdl

fastp_docu:
	wdl-aid wf_fastp.wdl -o wf_fastp.md
	womtool graph wf_fastp.wdl > wf_fastp.dot
	dot -Tpdf -o wf_fastp.pdf wf_fastp.dot
	dot -Tjpeg -o wf_fastp.jpeg wf_fastp.dot
	rm wf_fastp.dot

run_fastp:
	miniwdl run --debug --dir test-fastp --cfg miniwdl_production.cfg --input wf_fastp.json wf_fastp.wdl


#
# minimap3
#
minimap2:
	womtool validate --inputs wf_minimap2.json wf_minimap2.wdl
	miniwdl check wf_minimap2.wdl

minimap2_docu:
	wdl-aid wf_minimap2.wdl -o wf_minimap2.md
	womtool graph wf_minimap2.wdl > wf_minimap2.dot
	dot -Tpdf -o wf_minimap2.pdf wf_minimap2.dot
	dot -Tjpeg -o wf_minimap2.jpeg wf_minimap2.dot
	rm wf_minimap2.dot

run_minimap2:
	miniwdl run --debug --dir test-minimap2 --cfg miniwdl_production.cfg --input wf_minimap2.json wf_minimap2.wdl

run_minimap2_cromwell:
	cromwell run wf_minimap2.wdl -i wf_minimap2.json


#
# nextclade
#
nextclade:
	womtool validate --inputs wf_nextclade.json wf_nextclade.wdl
	miniwdl check wf_nextclade.wdl

nextclade_docu:
	wdl-aid wf_nextclade.wdl -o wf_nextclade.md
	womtool graph wf_nextclade.wdl > wf_nextclade.dot
	dot -Tpdf -o wf_nextclade.pdf wf_nextclade.dot
	dot -Tjpeg -o wf_nextclade.jpeg wf_nextclade.dot
	rm wf_nextclade.dot

run_nextclade:
	miniwdl run --debug --dir test-nextclade --cfg miniwdl_production.cfg --input wf_nextclade.json wf_nextclade.wdl


#
# pangolin
#
pangolin:
	womtool validate --inputs wf_pangolin.json wf_pangolin.wdl
	miniwdl check wf_pangolin.wdl

pangolin_docu:
	wdl-aid wf_pangolin.wdl -o wf_pangolin.md
	womtool graph wf_pangolin.wdl > wf_pangolin.dot
	dot -Tpdf -o wf_pangolin.pdf wf_pangolin.dot
	dot -Tjpeg -o wf_pangolin.jpeg wf_pangolin.dot
	rm wf_pangolin.dot

run_pangolin:
	miniwdl run --debug --dir test-pangolin --cfg miniwdl_production.cfg --input wf_pangolin.json wf_pangolin.wdl



#
# seqkit
#
seqkit:
	womtool validate --inputs wf_seqkit.json wf_seqkit.wdl
	miniwdl check wf_seqkit.wdl

seqkit_docu:
	wdl-aid wf_seqkit.wdl -o wf_seqkit.md
	womtool graph wf_seqkit.wdl > wf_seqkit.dot
	dot -Tpdf -o wf_seqkit.pdf wf_seqkit.dot
	dot -Tjpeg -o wf_seqkit.jpeg wf_seqkit.dot
	rm wf_seqkit.dot

run_seqkit:
	miniwdl run --debug --dir test-seqkit --cfg miniwdl_production.cfg --input wf_seqkit.json wf_seqkit.wdl

#
# centrifuge
#
centrifuge:
	womtool validate --inputs wf_centrifuge_large.json wf_centrifuge.wdl
	miniwdl check wf_centrifuge.wdl

centrifuge_docu:
	wdl-aid wf_centrifuge.wdl -o wf_centrifuge.md
	womtool graph wf_centrifuge.wdl > wf_centrifuge.dot
	dot -Tpdf -o wf_centrifuge.pdf wf_centrifuge.dot
	dot -Tjpeg -o wf_centrifuge.jpeg wf_centrifuge.dot
	rm wf_centrifuge.dot

run_centrifuge:
	miniwdl run --debug --dir test-centrifuge --cfg miniwdl_production.cfg --input wf_centrifuge_large.json wf_centrifuge.wdl

#
# qualimap
#
qualimap:
	womtool validate --inputs wf_qualimap.json wf_qualimap.wdl
	miniwdl check wf_qualimap.wdl

qualimap_docu:
	wdl-aid wf_qualimap.wdl -o wf_qualimap.md
	womtool graph wf_qualimap.wdl > wf_qualimap.dot
	dot -Tpdf -o wf_qualimap.pdf wf_qualimap.dot
	dot -Tjpeg -o wf_qualimap.jpeg wf_qualimap.dot
	rm wf_qualimap.dot

run_qualimap:
	#miniwdl run --debug --dir test-qualimap --cfg miniwdl_production.cfg --input wf_qualimap.json wf_qualimap.wdl
	miniwdl run --debug --dir test-qualimap --cfg miniwdl_production.cfg --input wf_qualimap_list.json wf_qualimap.wdl	

#
# ivar
#
ivar:
	womtool validate --inputs wf_ivar.json wf_ivar.wdl
	miniwdl check wf_ivar.wdl

ivar_docu:
	wdl-aid wf_ivar.wdl -o wf_ivar.md
	womtool graph wf_ivar.wdl > wf_ivar.dot
	dot -Tpdf -o wf_ivar.pdf wf_ivar.dot
	dot -Tjpeg -o wf_ivar.jpeg wf_ivar.dot
	rm wf_ivar.dot

run_ivar:
	miniwdl run --debug --dir test-ivar --cfg miniwdl_production.cfg --input wf_ivar.json wf_ivar.wdl

run_ivar_cromwell:
	cromwell run wf_ivar.wdl -i wf_ivar.json

#
# bbduk
#
bbduk:
	womtool validate --inputs wf_bbduk.json wf_bbduk.wdl
	miniwdl check wf_bbduk.wdl

bbduk_docu:
	wdl-aid wf_bbduk.wdl -o wf_bbduk.md
	womtool graph wf_bbduk.wdl > wf_bbduk.dot
	dot -Tpdf -o wf_bbduk.pdf wf_bbduk.dot
	dot -Tjpeg -o wf_bbduk.jpeg wf_bbduk.dot
	rm wf_bbduk.dot

run_bbduk:
	miniwdl run --debug --dir test-bbduk --cfg miniwdl_production.cfg --input wf_bbduk.json wf_bbduk.wdl

#
# samtools
#
samtools:
	womtool validate --inputs wf_samtools.json wf_samtools.wdl
	miniwdl check wf_samtools.wdl

samtools_docu:
	wdl-aid wf_samtools.wdl -o wf_samtools.md
	womtool graph wf_samtools.wdl > wf_samtools.dot
	dot -Tpdf -o wf_samtools.pdf wf_samtools.dot
	dot -Tjpeg -o wf_samtools.jpeg wf_samtools.dot
	rm wf_samtools.dot

run_samtools:
	miniwdl run --debug --dir test-samtools --cfg miniwdl_production.cfg --input wf_samtools.json wf_samtools.wdl

#
# mosdepth
#
mosdepth:
	womtool validate --inputs wf_mosdepth.json wf_mosdepth.wdl
	miniwdl check wf_mosdepth.wdl

mosdepth_docu:
	wdl-aid wf_mosdepth.wdl -o wf_mosdepth.md
	womtool graph wf_mosdepth.wdl > wf_mosdepth.dot
	dot -Tpdf -o wf_mosdepth.pdf wf_mosdepth.dot
	dot -Tjpeg -o wf_mosdepth.jpeg wf_mosdepth.dot
	rm wf_mosdepth.dot

run_mosdepth:
	miniwdl run --debug --dir test-mosdepth --cfg miniwdl_production.cfg --input wf_mosdepth.json wf_mosdepth.wdl

#
# bam_metrics
#
bam_metrics:
	womtool validate --inputs wf_bam_metrics.json wf_bam_metrics.wdl
	miniwdl check wf_bam_metrics.wdl

bam_metrics_docu:
	wdl-aid wf_bam_metrics.wdl -o wf_bam_metrics.md
	womtool graph wf_bam_metrics.wdl > wf_bam_metrics.dot
	dot -Tpdf -o wf_bam_metrics.pdf wf_bam_metrics.dot
	dot -Tjpeg -o wf_bam_metrics.jpeg wf_bam_metrics.dot
	rm wf_bam_metrics.dot

run_bam_metrics:
	miniwdl run --debug --dir test-bam_metrics --cfg miniwdl_production.cfg --input wf_bam_metrics.json wf_bam_metrics.wdl

#
# bam_metrics_list
#
bam_metrics_list:
	womtool validate --inputs wf_bam_metrics_list.json wf_bam_metrics_list.wdl
	miniwdl check wf_bam_metrics_list.wdl

bam_metrics_list_docu:
	wdl-aid wf_bam_metrics_list.wdl -o wf_bam_metrics_list.md
	womtool graph wf_bam_metrics_list.wdl > wf_bam_metrics_list.dot
	dot -Tpdf -o wf_bam_metrics_list.pdf wf_bam_metrics_list.dot
	dot -Tjpeg -o wf_bam_metrics_list.jpeg wf_bam_metrics_list.dot
	rm wf_bam_metrics_list.dot

run_bam_metrics_list:
	miniwdl run --debug --dir test-bam_metrics_list --cfg miniwdl_production.cfg --input wf_bam_metrics_list.json wf_bam_metrics_list.wdl

run_bam_metrics_list_no_targets:
	miniwdl run --debug --dir test-bam_metrics_list_no_targets --cfg miniwdl_production.cfg --input wf_bam_metrics_list_no_targets.json wf_bam_metrics_list.wdl


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


#!/bin/bash
#
# get SARS strains
#

# Wuhan
#wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/009/858/895/GCF_009858895.2_ASM985889v3/GCF_009858895.2_ASM985889v3_genomic.fna.gz
#gunzip GCF_009858895.2_ASM985889v3_genomic.fna.gz

# omicron
# BA.1
efetch -db nucleotide -format fasta -id OL672836.1 > sars_omicron_ba1.fasta

# BA.2
STRAIN=OM095411.1
efetch -db nucleotide -format fasta -id $STRAIN > sars_omicron_ba2.fasta

# BA.5
STRAIN=OP093778.1
efetch -db nucleotide -format fasta -id $STRAIN > sars_omicron_ba5.fasta

# XBB/JN.1
STRAIN=OR672203.1
efetch -db nucleotide -format fasta -id $STRAIN > sars_omicron_XBB-JN1.fasta

exit 0

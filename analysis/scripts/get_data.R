# load libraries
library(tidyverse)
library(rkip)
library(org.Hs.eg.db)
library(cgdsr)
library(cRegulome)

## gene expression data
url <- 'ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE104nnn/GSE104664/suppl/GSE104664%5Fcounts%5FtotalRNA%2Etxt%2Egz'

if(!file.exists('GSE104664_counts_totalRNA.txt.gz')) {
  download.file(url,
                destfile = 'data/GSE104664_counts_totalRNA.txt.gz')
}

## annotation data
if(!file.exists('data/annotations.tsv')) {
  ann <- annotation_get(
    go_id = c('GO:0006979', 'GO:0006914'),
    go_names = c('oxidative_stress', 'autophagy'),
    org_db = org.Hs.eg.db,
    columns = 'SYMBOL',
    remove_predicted = FALSE
  )

  write_tsv(ann, 'data/annotations.tsv')
}


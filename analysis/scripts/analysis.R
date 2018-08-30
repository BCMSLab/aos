# load required libraries
library(aos)
library(tidyverse)
library(reshape2)
library(WGCNA)
library(DESeq2)
library(org.Hs.eg.db)

# read data
df <- read_tsv('data/GSE104664_counts_totalRNA.txt.gz')
design <- data_frame(gsm = c('GSM2805219', 'GSM2805213', 'GSM2805216',
                             'GSM2805220', 'GSM2805214', 'GSM2805217',
                             'GSM2805221', 'GSM2805215', 'GSM2805218'),
                     names = names(df)[-1]) %>%
  mutate(treatment = str_split(names, ' ', simplify = TRUE)[, 3],
         time = str_split(names, ' ', simplify = TRUE)[, 4],
         time = case_when(time == '16h' ~ 16, time == '36h' ~ 36, TRUE ~ 0))

mat <- as.matrix(df[, -1])
colnames(mat) <- design$gsm
rownames(mat) <- df$gene

all(colnames(mat) == design$gsm)

# run deseq2
#dds.design <- data.frame(treatment = factor(design$treatment, levels = c('control', 'h2o2')),
#                         time = factor(design$time, levels = c('0', '16', '36')),
#                         row.names = design$gsm)
#
#dds <- DESeqDataSetFromMatrix(countData = mat,
#                              colData = dds.design,
#                              design = ~ time)
#dds <- DESeq(dds, test = 'LRT', reduced = ~1)

# load annotation
ann <- read_tsv('data/annotations.tsv')

# subset matrix
mat <- mat[rowSums(mat) > 1,]
mat <- log(mat + 1)
ind <- rownames(mat) %in% unique(ann$symbol)
dat <- t(mat[ind,])
dat <- dat[, colMeans(dat) > 0]

# pick threshold
sft <- pickSoftThreshold(dat)

# run cna
net <- cna_run(dat, power = 5)

genes <- data_frame(symbol = colnames(dat),
                    color = net$colors)

# clean and save
rm(df, ind)
save.image('data/aos_wgcna.rda')

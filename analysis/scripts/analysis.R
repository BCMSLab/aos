# load required libraries
library(aos)
library(tidyverse)
library(reshape2)
library(tidygraph)
library(WGCNA)
library(DESeq2)
library(clusterProfiler)
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
dds.design <- data.frame(treatment = factor(design$treatment, levels = c('control', 'h2o2')),
                         time = factor(design$time, levels = c('0', '16', '36')),
                         row.names = design$gsm)

dds <- DESeqDataSetFromMatrix(countData = mat,
                              colData = dds.design,
                              design = ~ treatment)
dds <- DESeq(dds)
#dds <- DESeq(dds, test = 'LRT', reduced = ~1)
dds.res <- results(dds)

# load annotation
ann <- read_tsv('data/annotations.tsv')

# subset matrix
mat1 <- mat[rowSums(mat) > 1,]
mat1 <- log(mat1 + 1)
ind <- rownames(mat1) %in% unique(ann$symbol)
dat <- t(mat1[ind,])
dat <- dat[, colMeans(dat) > 0]

# pick threshold
sft <- pickSoftThreshold(dat)

# run cna
net <- cna_run(dat, power = 5)

genes <- data_frame(symbol = colnames(dat),
                    color = net$colors)

# make graph
uniq_ann <- ann %>%
  dplyr::select(symbol, category) %>%
  unique()
ind <- uniq_ann$symbol[duplicated(uniq_ann$symbol)]

uniq_ann <- uniq_ann %>%
  mutate(category = ifelse(symbol %in% ind, 'both', category)) %>%
  unique()

network <- exportNetworkToVisANT(net$adj, threshold = 0) %>%
  left_join(genes, by = c('from'='symbol')) %>%
  left_join(genes, by = c('to'='symbol')) %>%
  mutate(color = ifelse(color.x == color.y, color.x, 'inbetween')) %>%
  dplyr::select(from, to, weight, color) %>%
  as_tbl_graph() %>%
  left_join(uniq_ann, by = c('name' = 'symbol')) %>%
  left_join(genes, by = c('name' = 'symbol'))

# overrepresentation
ind <- with(genes, split(symbol, color))
mod <- model.matrix(~design$treatment)

log_mat <- log(mat + 1)
mr <- limma::mroast(log_mat,
                    index = ind,
                    design = mod)

# cluster profiles
go_enrichment <- compareCluster(ind,
                                   fun = 'enrichGO',
                                   OrgDb = 'org.Hs.eg.db',
                                   ont = 'MF',
                                   keyType = 'SYMBOL') %>%
  gofilter(level = 4) %>%
  as.data.frame()

# clean and save
rm(df, ind, uniq_ann, dds, log_mat, mat1, dds.design, dat)
save.image('data/aos_wgcna.rda')

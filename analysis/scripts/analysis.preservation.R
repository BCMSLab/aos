# load required libraries
library(aos)
library(tidyverse)
library(WGCNA)
library(GEOquery)

load('data/aos_wgcna.rda')

allowWGCNAThreads(3)

multi_data <- list()

# GSE104664
ind <- rownames(mat) %in% unique(ann$symbol)
multi_data[['GSE104664']] <- list(data = t(mat[ind,]))

# GSE87666
e <- getGEO('GSE87666', destdir = 'data/')[[1]]
mat <- exprs(e)
fd <- fData(e)
mat <- collapseRows(mat,
                    rowGroup = fd$GENE_SYMBOL,
                    rowID = rownames(mat))
mat <- mat$datETcollapsed

ind <- rownames(mat) %in% unique(ann$symbol)

multi_data[['GSE87666']] <- list(data = t(mat[ind,]))

# GSE55696
e <- getGEO('GSE55696', destdir = 'data/')[[1]]
mat <- exprs(e)
fd <- fData(e)
mat <- collapseRows(mat,
                    rowGroup = fd$GENE_SYMBOL,
                    rowID = rownames(mat))
mat <- mat$datETcollapsed

ind <- rownames(mat) %in% unique(ann$symbol)

multi_data[['GSE55696']] <- list(data = t(mat[ind,]))

# GSE78523
e <- getGEO('GSE78523', destdir = 'data/')[[1]]
mat <- exprs(e)
fd <- fData(e)
mat <- collapseRows(mat,
                    rowGroup = fd$`Gene Symbol`,
                    rowID = rownames(mat))
mat <- mat$datETcollapsed

ind <- rownames(mat) %in% unique(ann$symbol)

multi_data[['GSE78523']] <- list(data = t(mat[ind,]))

ind <- map(multi_data, function(x) {
  goodSamplesGenes(x$data)
})
multi_data$GSE104664$data <- multi_data$GSE104664$data[, ind$GSE104664$goodGenes]


multi_color <- genes$color
names(multi_color) <- genes$symbol
multi_color <- list(GSE104664 = multi_color)

multi_color$GSE104664 <- multi_color$GSE104664[ind$GSE104664$goodGenes]

mod_preserve <- modulePreservation(multiData = multi_data,
                                   multiColor = multi_color,
                                   nPermutations = 10)

saveRDS(mod_preserve, 'data/aos_preservation.rds')

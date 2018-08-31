# load required libraries
library(tidyverse)
library(xtable)

# global variables
tables_dir <- 'manuscript/tables'

# load data
load('data/aos_wgcna.rda')

# generate table
dds.res %>%
  as.data.frame() %>%
  rownames_to_column('symbol') %>%
  na.omit() %>%
  filter(padj < .2) %>%
  dplyr::select(symbol, log2FoldChange, padj) %>%
  inner_join(genes) %>%
  arrange(color) %>%
  mutate(color = ifelse(duplicated(color), '', color),
         padj = round(padj, 2),
         log2FoldChange = round(2^log2FoldChange, 2)) %>%
  dplyr::select(color, everything()) %>%
  setNames(c('Module', 'Gene', 'Fold Change', 'Adjusted p-value')) %>%
  xtable(caption = 'Differential expression between control and H2O2 treated samples.',
         label = 'tab:diff_expression',
         align = 'cllcc') %>%
  print(include.rownames = FALSE,
        booktabs = TRUE,
        caption.placement = 'top',
        table.placement = '!ht',
        add.to.row = list(pos = list(14,15),
                          command = rep('\\midrule ', 2)),
        sanitize.text.function = identity,
        comment = FALSE,
        file = paste(tables_dir, 'diff_expression.tex', sep = '/'))

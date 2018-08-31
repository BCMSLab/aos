# load required libraries
library(tidyverse)
library(xtable)

# load data
load('data/aos_wgcna.rda')

# global variables
tables_dir <- 'manuscript/tables'

# generate tables
go_enrichment %>%
  as.data.frame() %>%
  filter(Cluster != 'grey') %>%
  select(Cluster, ID, Description, Count, p.adjust) %>%
  mutate(Cluster = ifelse(duplicated(Cluster), '', as.character(Cluster)),
         p.adjust = ifelse(p.adjust < .1, '$<$ 0.1', round(p.adjust, 2))) %>%
  setNames(c('Module', 'GO ID', 'GO Term', 'Count', 'Adjusted p-value')) %>%
  xtable(caption = 'Gene Ontology (molecular function) enrichment.',
         label = 'tab:go_enrichment',
         align = 'cllp{.4\\textwidth}cc') %>%
  print(include.rownames = FALSE,
        booktabs = TRUE,
        caption.placement = 'top',
        table.placement = '!ht',
        add.to.row = list(pos = list(4,9),
                          command = rep('\\midrule ', 2)),
        sanitize.text.function = identity,
        comment = FALSE,
        file = paste(tables_dir, 'go_enrichment.tex', sep = '/'))

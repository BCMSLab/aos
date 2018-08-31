# load required libraries
library(tidyverse)
library(xtable)
library(tidygraph)

# load data
load('data/aos_wgcna.rda')

# global variables
tables_dir <- 'manuscript/tables'

# generate table
network %>%
  activate('edges') %>%
  filter(weight > .5) %>%
  activate('nodes') %>%
  filter(!node_is_isolated()) %>%
  mutate(degree = centrality_degree()) %>%
  as_tibble() %>%
  group_by(color) %>%
  top_n(5, wt = degree) %>%
  arrange(color, category) %>%
  mutate(module = ifelse(duplicated(color), '', color),
         category = ifelse(duplicated(category), '', category),
         category = ifelse(category == 'oxidative_stress',
                           'response to oxidative stress', category),
         degree = as.integer(degree)) %>%
  ungroup() %>%
  dplyr::select(module, category, everything(), -color) %>%
  setNames(c('Module', 'GO Term', 'Gene', 'Degree')) %>%
  xtable(caption = 'Graph top nodes by module and gene ontology category.',
         label = 'tab:network_stats',
         align = 'clllc') %>%
  print(include.rownames = FALSE,
        booktabs = TRUE,
        caption.placement = 'top',
        table.placement = '!ht',
        add.to.row = list(pos = list(5, 10, 4, 7, 8, 14),
                          command = c(rep('\\midrule ', 2), rep('\\cmidrule{2-4} ', 4))),
        sanitize.text.function = identity,
        comment = FALSE,
        file = paste(tables_dir, 'network_stats.tex', sep = '/'))

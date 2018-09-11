# load required libraries
library(tidyverse)
library(tidygraph)
library(WGCNA)
library(xtable)

# load data
load('data/aos_wgcna.rda')

exportNetworkToVisANT(net$adj, threshold = .8) %>%
  left_join(genes, by = c('from'='symbol')) %>%
  left_join(genes, by = c('to'='symbol')) %>%
  mutate(color = ifelse(color.x == color.y, color.x, 'inbetween')) %>%
  dplyr::select(from, to, color) %>%
  group_by(color, from) %>%
  summarise(to = paste(unique(to), collapse = ', ')) %>%
  ungroup() %>%
  mutate(color = ifelse(duplicated(color), '', color)) %>%
  setNames(c('Module', 'Gene 1', 'Gene 2')) %>%
  xtable(caption = 'Novel interactions of autophagy and oxidative stress.',
         label = 'tab:novel_interactions',
         align = 'cllp{.6\\textwidth}') %>%
  print(include.rownames = FALSE,
        caption.placement = 'top',
        booktabs = TRUE,
        table.placement = '!ht',
        sanitize.text.function = identity,
        add.to.row = list(pos = list(9, 15, 16),
                          command = rep('\\midrule ', 3)),
        comment = FALSE,
        file = 'manuscript/tables/novel_interactions.tex')

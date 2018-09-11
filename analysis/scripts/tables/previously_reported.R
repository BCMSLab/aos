# load required libraries
library(tidyverse)
library(tidygraph)
library(WGCNA)
library(xtable)

# load data
load('data/aos_wgcna.rda')

prev <- read_tsv('data/interactions_evidence.tsv')[, -1] %>%
  filter(evidence != 'combined_score') %>%
  mutate(evidence = str_split(evidence, '\\_', simplify = TRUE)[, 1]) %>%
  dplyr::select(-value) %>%
  unique()

exportNetworkToVisANT(net$adj, threshold = .5) %>%
  left_join(genes, by = c('from'='symbol')) %>%
  left_join(genes, by = c('to'='symbol')) %>%
  mutate(color = ifelse(color.x == color.y, color.x, 'inbetween')) %>%
  dplyr::select(from, to, weight, color) %>%
  inner_join(prev) %>%
  mutate(tnote = as.numeric(as.factor(evidence))) %>%
  with({

    footnotes <- dplyr::select(., evidence, tnote) %>%
      arrange(tnote) %>%
      unique() %>%
      mutate(footnote = paste0('$^{', tnote, '}$', evidence)) %>%
      pull(footnote) %>%
      paste(collapse = ' ')

    group_by(., color, from, to) %>%
      summarise(tnote = paste(tnote, collapse = ',')) %>%
      ungroup() %>%
      mutate(to = paste0(to,'$^{', tnote,'}$')) %>%
      group_by(color, from) %>%
      summarise(to = paste(to, collapse = ', ')) %>%
      ungroup() %>%
      mutate(color = ifelse(duplicated(color), '', color)) %>%
      setNames(c('Module', 'Gene 1', 'Gene 2')) %>%
      xtable(caption = 'Previously reported interactions of autophagy and oxidative stress.',
             label = 'tab:previously_reported',
             align = 'cp{.1\\textwidth}lp{.6\\textwidth}') %>%
      print(include.rownames = FALSE,
            caption.placement = 'top',
            table.placement = '!ht',
            hline.after = NULL,
            add.to.row = list(pos = list(-1, 0, 8, 12, 17, 42),
                              command = c('\\toprule ', '\\midrule ', rep('\\midrule ', 3), paste('\\bottomrule ', footnotes))),
            sanitize.text.function = identity,
            comment = FALSE,
            file = 'manuscript/tables/previously_reported.tex')
    footnotes
  })

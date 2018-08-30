# load libraries
library(tidyverse)
library(xtable)
library(reshape2)

# load data
load('data/aos_wgcna.rda')

# global variables
tables_dir <- 'manuscript/tables'

# generate table
data_frame(term = c('response to oxidative stress',
                    'autophagy'),
           go = c("GO:0006979", "GO:0006914")) %>%
  left_join(ann) %>%
  left_join(genes) %>%
  na.omit() %>%
  filter(color != 'grey') %>%
  mutate(symbol = paste('\\emph{', symbol, '}', sep = '')) %>%
  group_by(color, term) %>%
  summarise(gene = paste(unique(symbol), collapse = ', ')) %>%
  spread(term, gene) %>%
  setNames(c('Module', 'response to oxidative stress',
             'autophagy')) %>%
  xtable(caption = 'Gene members in different modules/colors.',
         label = 'tab:module_members',
         align = 'clp{.4\\textwidth}p{.4\\textwidth}') %>%
  print(include.rownames = FALSE,
        booktabs = TRUE,
        caption.placement = 'top',
        table.placement = '!ht',
        add.to.row = list(pos = list(1,2),
                          command = rep('\\midrule ', 2)),
        sanitize.text.function = identity,
        comment = FALSE,
        file = paste(tables_dir, 'module_members.tex', sep = '/'))

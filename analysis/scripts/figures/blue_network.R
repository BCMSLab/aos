# loading required libraries
library(tidyverse)
library(tidygraph)
library(ggraph)
library(WGCNA)

# loading data
load('data/aos_wgcna.rda')

mr
# generate figure
uniq_ann <- ann %>%
  select(symbol, category) %>%
  unique()
ind <- uniq_ann$symbol[duplicated(uniq_ann$symbol)]

uniq_ann <- uniq_ann %>%
  mutate(category = ifelse(symbol %in% ind, 'both', category)) %>%
  unique()

network <- exportNetworkToVisANT(net$adj, threshold = 0) %>%
  left_join(genes, by = c('from'='symbol')) %>%
  left_join(genes, by = c('to'='symbol')) %>%
  mutate(color = ifelse(color.x == color.y, color.x, 'inbetween')) %>%
  select(from, to, weight, color) %>%
  as_tbl_graph() %>%
  left_join(uniq_ann, by = c('name' = 'symbol'))

ind <-  c('FGF8', 'MDL2','RAB24', 'PTGS1', 'WIPI1','ABCC2','CA3','TAT', 'PXDNL')
network %>%
  activate('edges') %>%
  filter(weight > .5) %>%
  activate('nodes') %>%
  filter(!name %in% ind, !node_is_isolated()) %>%
  mutate(hub = centrality_hub()) %>%
  ggraph(layout = 'kk') +
  geom_edge_link(aes(color = color)) +
  geom_node_point(aes(shape = category, size = hub)) +
#  geom_node_text(aes(label = name)) +
  theme_graph()

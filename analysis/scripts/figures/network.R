# loading required libraries
library(tidyverse)
library(tidygraph)
library(ggraph)
library(WGCNA)

# loading data
load('data/aos_wgcna.rda')

# generate figure
ind <-  c('FGF8', 'MDL2','RAB24', 'PTGS1', 'WIPI1','ABCC2','CA3','TAT', 'PXDNL')

(network %>%
    activate('edges') %>%
    filter(weight > .5) %>%
    activate('nodes') %>%
    filter(!name %in% ind, !node_is_isolated()) %>%
    mutate(hub = centrality_hub()) %>%
    ggraph(layout = 'kk') +
    geom_edge_link(aes(color = color), alpha = .4) +
    geom_node_point(aes(shape = category, size = hub), alpha = .8) +
    scale_edge_color_manual(values = c('blue', 'brown', 'gray', 'turquoise')) +
    theme_graph() +
    theme(legend.position = 'top',
          legend.direction = 'vertical')) %>%
  ggsave(plot = .,
         filename = 'manuscript/figures/network.png',
         width = 25, height = 20, units = 'cm')

library(tidyverse)
library(reshape2)
library(cowplot)

load('data/aos_wgcna.rda')

figures_dir <- 'manuscript/figures'

ind <- rownames(mat) %in% unique(ann$symbol)
cor(t(mat[ind, ]), as.numeric(as.factor(design$time))) %>%
  as.data.frame() %>%
  setNames('cor') %>%
  rownames_to_column('symbol')

plot_grid(
  dplyr::select(design, time, treatment) %>%
    mutate_all(function(x) as.numeric(as.factor(x))) %>%
    map(function(x) {
      cor(t(mat[ind,]), x) %>%
        as.data.frame() %>%
        setNames('cor') %>%
        rownames_to_column('symbol')
    }) %>%
    bind_rows(.id = 'type') %>%
    spread(type, cor) %>%
    left_join(genes) %>%
    filter(color != 'grey') %>%
    na.omit() %>%
    ggplot(aes(x = time, y = treatment, color = color)) +
    geom_point(alpha = .5) +
    scale_color_manual(values = c('blue', 'brown', 'turquoise')) +
    lims(x = c(-1, 1), y = c(-1,1)) +
    labs(x = 'Correlation with Time', y = 'Correlation with Treatment') +
    theme_bw() +
    theme(legend.position = 'none'),

  cmdscale(net$diss) %>%
    as.data.frame() %>%
    setNames(c('PC1', 'PC2')) %>%
    mutate(color = net$colors) %>%
    filter(color != 'grey') %>%
    ggplot(aes(x = PC1, y = PC2, color = color)) +
    geom_point(alpha = .5) +
    scale_color_manual(values = c('blue', 'brown', 'turquoise')) +
    theme_bw() +
    theme(legend.position = 'none'),
  labels = 'AUTO',
  label_size = 10,
  label_fontface = 'plain',
  scale = .9
) %>%
  ggsave(plot = .,
         filename = paste(figures_dir, 'member_significance.png', sep = '/'),
         width = 20, height = 9, units = 'cm')

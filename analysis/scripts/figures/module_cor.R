# load libraries
library(tidyverse)
library(cowplot)

# load data
load('data/aos_wgcna.rda')

# global variables
figures_dir = 'manuscript/figures'

# generate figure

plot_grid({
  corr <- cor(net$mes, as.numeric(as.factor(design$treatment)))
  data_frame(cor = corr[, 1],
             color = str_sub(rownames(corr), start = 3)) %>%
    filter(color != 'grey') %>%
    ggplot(aes(x = color, y = cor)) +
    geom_col() +
    theme_bw() +
    lims(y = c(0, 1)) +
    labs(x = '', y = "Pearsons's Correlation")
  },
  cmdscale(net$diss) %>%
    as.data.frame() %>%
    setNames(c('PC1', 'PC2')) %>%
    mutate(color = net$colors) %>%
    filter(color != 'grey') %>%
    ggplot(aes(x = PC1, y = PC2, color = color)) +
    geom_point() +
    scale_color_manual(values = c('blue', 'brown', 'turquoise')) +
    theme_bw() +
    theme(legend.position = 'none'),
  labels = 'AUTO',
  label_size = 10,
  label_fontface = 'plain',
  scale = .9
) %>%
  ggsave(plot = .,
         filename = paste(figures_dir, 'module_cor.png', sep = '/'),
         width = 16, height = 7, units = 'cm')

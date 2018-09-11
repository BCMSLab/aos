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
  data_frame(color = rownames(mr),
             prop = mr$PropDown + mr$PropUp,
             fdr = mr$FDR.Mixed) %>%
    filter(color != 'grey') %>%
    ggplot(aes(x = color, y = prop)) +
    geom_col() +
    theme_bw() +
    lims(y = c(0, 1)) +
    labs(x = '', y = "Proportion of DE genes"),
  labels = 'AUTO',
  label_size = 10,
  label_fontface = 'plain',
  scale = .9
) %>%
  ggsave(plot = .,
         filename = paste(figures_dir, 'module_cor.png', sep = '/'),
         width = 16, height = 7, units = 'cm')


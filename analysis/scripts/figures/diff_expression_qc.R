# load required libraries
library(tidyverse)
library(cowplot)

# load data
load('data/aos_wgcna.rda')

# global variables
figures_dir <- 'manuscript/figures'

# generate figures
df <- dds.res %>%
  as.data.frame() %>%
  na.omit()

plot_grid(
  df %>%
    ggplot(aes(x = log2(baseMean), y = log2FoldChange, color = padj < .2)) +
    geom_point(alpha = .3) +
    theme_bw() +
    lims(y = c(-4, 4)) +
    labs(x = 'Log2 Mean-expression',
         y = 'Log2 Fold-change') +
    scale_color_manual(values = c('black', 'red')) +
    theme(legend.position = 'none'),
  df %>%
    ggplot(aes(x = log2FoldChange, y = -log10(pvalue), color = padj < .2)) +
    geom_point(alpha = .2) +
    theme_bw() +
    lims(x = c(-4, 4), y = c(0, 20)) +
    scale_color_manual(values = c('black', 'red')) +
    theme(legend.position = 'none') +
    labs(y = '- Log10 p-value',
         x = 'Log2 Fold-change'),
  df %>%
    ggplot(aes(x = stat)) +
    geom_histogram(fill = 'gray', color = 'darkgray') +
    theme_bw() +
    lims(x = c(-6, 6)) +
    labs(x = 't-statistics', y = 'Count'),
  df %>%
    ggplot(aes(x = pvalue)) +
    geom_histogram(fill = 'gray', color = 'darkgray') +
    theme_bw() +
    labs(x = 'p-values', y = 'Count'),
  labels = 'AUTO',
  label_size = 10,
  label_fontface = 'plain',
  nrow = 2,
  scale = .9
) %>%
  ggsave(plot = .,
         filename = paste(figures_dir, 'diff_expression_qc.png', sep = '/'),
         width = 20, height = 20, units = 'cm')


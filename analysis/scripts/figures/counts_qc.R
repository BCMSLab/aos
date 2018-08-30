# load required libraries
library(tidyverse)
library(reshape2)
library(cowplot)

# load data
load('data/aos_wgcna.rda')

# global variables
figures_dir <- 'manuscript/figures'

# generate figure
plot_grid(melt(mat) %>%
            left_join(design, by = c('Var2'='gsm')) %>%
            ggplot(aes(x = Var2, y = value, fill = time)) +
            geom_boxplot() +
            theme_bw() +
            theme(axis.text.x = element_text(angle = 45, size = 5, hjust = 1),
                  legend.position = 'none') +
            labs(x = '', y = 'Log2 (counts + 1)'),
          cmdscale(dist(t(mat))) %>%
            as.data.frame() %>%
            rownames_to_column('gsm') %>%
            left_join(design) %>%
            ggplot(aes(x = V1, y = V2, color = time)) +
            geom_point() +
            theme_bw() +
            theme(plot.margin = margin(c(1,1,20,1)),
                  legend.position = 'none') +
            labs(x = 'PC1', y = 'PC2'),
          labels = 'AUTO',
          label_size = 10,
          label_fontface = 'plain',
          scale = .9) %>%
  ggsave(plot = .,
         filename = paste(figures_dir, 'counts_qc.png', sep = '/'),
         width = 16, height = 8, units = 'cm')

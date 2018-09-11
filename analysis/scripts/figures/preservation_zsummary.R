# load libraries
library(tidyverse)
library(reshape2)

# load data
mod_preserve <- readRDS('data/aos_preservation.rds')

# global variables
figures_dir = 'manuscript/figures'

# generate figure

mod_preserve$quality$Z[[1]][-1] %>%
    map(rownames_to_column, var = 'color') %>%
    bind_rows(.id = 'study') %>%
    mutate(study = str_split(study, '\\.', simplify = TRUE)[, 2]) %>%
    ggplot(aes(x = moduleSize, y = Zsummary.qual, color = color)) +
    geom_point() +
    geom_abline(intercept = c(2,5), slope = 0, lty = 2) +
    theme_bw() +
    theme(legend.position = 'top') +
    facet_wrap(~study, nrow = 1) +
    labs(x = 'Module Size', y = 'Preservation Z Summary', color = '') +
    guides(color = guide_legend(nrow = 1))
  ggsave(plot = .,
         filename = paste(figures_dir, 'preservation_zsummary.png', sep = '/'),
         width = 20, height = 12, units = 'cm')

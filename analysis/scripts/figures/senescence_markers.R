# load libraries
library(tidyverse)
library(reshape2)

load('data/aos_wgcna.rda')

figures_dir <- 'manuscript/figures'

ind <- c('CDKN1A', 'CDKN2A', 'CXCL8', 'TNFRSF10D', 'GDF15')

(mat[rownames(mat) %in% ind,] %>%
  melt %>%
  setNames(c('symbol', 'gsm', 'expr')) %>%
  left_join(design) %>%
  group_by(time, symbol) %>%
  mutate(ave = mean(log(expr)),
         sd = sd(log(expr))) %>%
  ggplot() +
  geom_jitter(aes(x = as.factor(time), y = log(expr)), width = .25, size = 2.5, alpha = .5) +
  geom_point(aes(x = as.factor(time), y = ave), color = 'red') +
  geom_linerange(aes(x = as.factor(time), ymin = ave - sd, ymax = ave + sd), color = 'red') +
  facet_wrap(~symbol, nrow = 1) +
  theme_bw() +
  labs(x = 'Time Point (hr)', y = 'Log2 mRNA Level')) %>%
  ggsave(plot = .,
         filename = paste(figures_dir, 'senescence_markers.png', sep = '/'),
         width = 16, height = 8, units = 'cm')


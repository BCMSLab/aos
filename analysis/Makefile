R_OPT=--vanilla

SCRIPTS=scripts
FIG_SRC=scripts/figures
TAB_SRC=scripts/tables

MANUSCRIPT=manuscript
FIG_DIR=manuscript/figures
TAB_DIR=manuscript/tables

DATA=data
LOG=log

all: $(LOG)/get_data.R.Rout \
	$(DATA)/aos_wgcna.rda \
	$(FIG_DIR)/counts_qc.png \
	$(FIG_DIR)/diff_expression_qc.png \
	$(FIG_DIR)/gene_membership.png \
	$(FIG_DIR)/member_significance.png \
	$(FIG_DIR)/module_cor.png \
	$(FIG_DIR)/network.png \
	$(FIG_DIR)/sft_power.png \
	$(FIG_DIR)/senescence_markers.png \
	$(TAB_DIR)/diff_expression.tex \
	$(TAB_DIR)/go_enrichment.tex \
	$(TAB_DIR)/go_genes.tex \
	$(TAB_DIR)/module_members.tex \
	$(TAB_DIR)/network_stats.tex \
	$(TAB_DIR)/novel_interactions.tex \
	$(TAB_DIR)/previously_reported.tex \
	clean

# install/update the functions
install:
	Rscript -e "devtools::install('..')"

# make directory tree
dir_tree:
	test ! -d $(LOG) && mkdir $(LOG) || echo '$(LOG)/ is already there.'
	test ! -d $(DATA) && mkdir $(DATA) || echo '$(DATA)/ is already there.'
	test ! -d $(MANUSCRIPT) && mkdir $(MANUSCRIPT) || echo '$(MANUSCRIPT)/ is already there.'
	test ! -d $(TAB_DIR) && mkdir $(TAB_DIR) || echo '$(TAB_DIR)/ is already there.'
	test ! -d $(FIG_DIR) && mkdir $(FIG_DIR) || echo '$(FIG_DIR)/ is already there.'

# get data
$(LOG)/get_data.R.Rout: $(SCRIPTS)/get_data.R
	R CMD BATCH $(R_OPT) $< $(LOG)/$(<F).Rout

# run the main part of the analysis
$(DATA)/aos_wgcna.rda: $(SCRIPTS)/analysis.R
	R CMD BATCH $(R_OPT) $< $(LOG)/$(<F).Rout

$(DATA)/aos_preservation.rds: $(SCRIPTS)/analysis.preservation.R $(DATA)/*
	R CMD BATCH $(R_OPT) $< $(LOG)/$(<F).Rout

# generate tables
$(TAB_DIR)/%.tex: $(TAB_SRC)/%.R
	R CMD BATCH $(R_OPT) $< $(LOG)/$(<F).Rout

# generate figures
$(FIG_DIR)/%.png: $(FIG_SRC)/%.R
	R CMD BATCH $(R_OPT) $< $(LOG)/$(<F).Rout

# clean up
.PHONY: clean
clean:
	rm -f *.pdf
	rm -f *.RData

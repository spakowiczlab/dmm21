ascripts <- list.files("analysis-scripts/", full.names = T)
lapply(ascripts, source)

#RBerry figures

rber.seq <- readRDS("../data/rberry/2020-12-18_seqtabNoCf.RDS")
rber.tax <- readRDS("../data/rberry/2020-12-18_taxf.RDS")
rber.groups <- formatRBgroups()

rber.desres <- difMicsRB(rber.seq, rber.tax, rber.groups)

save(rber.desres, file = "../data/figure-data/desres_rberry.rda")

#BEWELL figures

bewell.tax <- read.csv("../data/BEWELL/bewell_taxonomy_relAbun.csv")

stackdatBW <- stackedBarBEWELL(bewell.tax, 7)
model_res_BW <- modelBW(bewell.tax)
mic_fc_BW <- foldchangeBW(bewell.tax)

save(stackdatBW, file = "../data/figure-data/stackedbar_bewell.rda")
save(model_res_BW, mic_fc_BW, file = "../data/figure-data/model_stats_BW.rda")

#mimic figures

mimic.sum <- read.csv("../data/mimic/2024-02-05_tumor-size_R-formatted.csv")
mimic10.means <- tumorVolTime(mimic.sum)
mimic1819.means <- tumorVolTimeBlau(mimic.sum)

mimic.respose <- blautiaResponse(mimic.sum)

mim.boxdat <- mimicBoxPrep(mimic.sum)
mim.boxflow <- mimicBoxFlo("../data/mimic/30-Jun-2022 revised.wsp FlowJo table_man-edited.csv")

mimic.longmods <- quadLongMod(mimic.sum)

save(mimic10.means, file = "../data/figure-data/tvol_m10.rda")
save(mimic1819.means, file = "../data/figure-data/tvol_m1819.rda")
save(mimic.respose, file = "../data/figure-data/fracresponse_blautia-gavage.rda")
save(mim.boxdat, mim.boxflow, file = "../data/figure-data/boxdat_mimic.rda")
save(mimic.longmods, file = "../data/figure-data/longmods_mimic-heatmap.rda")

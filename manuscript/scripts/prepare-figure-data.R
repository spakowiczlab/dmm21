ascripts <- list.files("analysis-scripts", full.names = T)
lapply(ascripts, source)

#RBerry figures

rber.seq <- readRDS("../data/rberry/2020-12-18_seqtabNoCf.RDS")
rber.tax <- readRDS("../data/rberry/2020-12-18_taxf.RDS")
rber.groups <- formatRBgroups()

rber.pca <- seqToPCAplot(rber.seq, rber.groups)

rber.desres <- difMicsRB(rber.seq, rber.tax, rber.groups)

save(rber.pca, file = "../data/figure-data/pca_rberry.rda")
save(rber.desres, file = "../data/figure-data/desres_rberry.rda")

#BEWELL figures

bewell.tax <- read.csv("../data/BEWELL/bewell_taxonomy_relAbun.csv")

stackdatBW <- stackedBarBEWELL(bewell.tax, 7)
model_res_BW <- modelBW(bewell.tax)
mic_fc_BW <- foldchangeBW(bewell.tax)

Bo_abun_BW <- barMicAbun(bewell.tax)

lachno.phylo <- preparePhyloDat(bewell.tax, model_res_BW, 0.05)

save(stackdatBW, file = "../data/figure-data/stackedbar_bewell.rda")
save(model_res_BW, mic_fc_BW, file = "../data/figure-data/model_stats_BW.rda")
save(Bo_abun_BW, file = "../data/figure-data/bardat_Bo_BW.rda")
save(lachno.phylo, file = "../data/figure-data/phylo_lacho-bewell.rda")

#mimic figures

mimic.sum <- read.csv("../data/mimic/2024-02-05_tumor-size_R-formatted.csv")
mim.sampkey <- read.csv("../data/mimic/mimic16S-key.csv")
mimic.seqtab <-readRDS("../data/mimic/2023-07-26_16S-seqtab.rds")
mimic.tax <- readRDS("../data/mimic/2023-07-26_16S-taxa.rds")
mimic10.means <- tumorVolTime(mimic.sum)
mimic1819.means <- tumorVolTimeBlau(mimic.sum)

mimic.respose <- blautiaResponse(mimic.sum)

mim.boxdat <- mimicBoxPrep(mimic.sum)
mim.boxflow <- mimicBoxFlo("../data/mimic/30-Jun-2022 revised.wsp FlowJo table_man-edited.csv")

mim.rosebur <- barDatMimic(mimic.seqtab, mimic.tax, mim.sampkey)

mimic.longmods <- quadLongMod(mimic.sum)

save(mimic10.means, file = "../data/figure-data/tvol_m10.rda")
save(mimic1819.means, file = "../data/figure-data/tvol_m1819.rda")
save(mimic.respose, file = "../data/figure-data/fracresponse_blautia-gavage.rda")
save(mim.boxdat, mim.boxflow, file = "../data/figure-data/boxdat_mimic.rda")
save(mim.rosebur, file = "../data/figure-data/bardat_mimic_roseburia.rda")
save(mimic.longmods, file = "../data/figure-data/longmods_mimic-heatmap.rda")

<table>
<tr>
<td>

# bewell-mice

Black raspberry nectar, the gut microbiome, and immune checkpoint response

</td>
<td align="right" width="220">

<img src="dmm21-hex.svg" width="200" alt="bewell-mice hex sticker">

</td>
</tr>
</table>

This repository contains the code and figure panels for the mouse-model paper that accompanies the BE WELL clinical trial. BE WELL tested whether four weeks of black raspberry nectar changes the gut microbiome of people at high risk for lung cancer ([NCT04267874](https://clinicaltrials.gov/study/NCT04267874)). This paper asks whether those microbiome changes, and one of the enriched species (*Blautia obeum*), are sufficient to improve anti-PD-1 response after the stool is transferred into tumor-bearing mice.

The trial itself is a separate public repository: [spakowiczlab/bewell](https://github.com/spakowiczlab/bewell). Enrollment, the nectar, urine polyphenols, cytokines, and the trial microbiome figures are documented there. This repository starts where that one stops: the rat feeding study, the comparison of BE WELL stool to published immunotherapy-response signatures, the mouse fecal-transfer experiments, and the Blautia and metabolomics follow-up.

## Citation

Jahanbahkshi S*, Bibi A*, Hoyd R, Dravillas C, Williams N, Zhang S, Pallerla A, Suman S, Amann J, Goruganthu M, Okimoto T, Liu Y, Bittoni MA, Shi N, Anand A, Conrad B, Nevers L, Heitman K, Webb M, Grainger EM, Grogan M, Quiles C, Chen T, Presley CJ, Li L, Bradley P, Vodovotz Y, Carbone DP, Clinton SK, Zhu J, Spakowicz D. Berry Supplement-Modified Human Microbiome Improves Immunotherapy Response in Mouse Models. Manuscript submitted for publication.

\*These authors contributed equally.

A preprint of an earlier version is on medRxiv: [doi:10.1101/2025.01.16.25320666](https://doi.org/10.1101/2025.01.16.25320666).

Corresponding author: [daniel.spakowicz@osumc.edu](mailto:daniel.spakowicz@osumc.edu).

The companion trial manuscript is cited from [spakowiczlab/bewell](https://github.com/spakowiczlab/bewell).

## How a reviewer regenerates the figures

Panel letters below match the figures in the submitted manuscript.

Run [`manuscript/scripts/prepare-figure-data.R`](manuscript/scripts/prepare-figure-data.R) from `manuscript/scripts/` before knitting Figures 1–3. It sources every file in [`manuscript/scripts/analysis-scripts/`](manuscript/scripts/analysis-scripts/) and writes `.rda` files to `manuscript/data/figure-data/`. Each function there has a roxygen header describing its inputs and what it returns. The Figure 1–3 notebooks load those objects. They do not re-fit the models. The notebooks for Figure 3B, Figure 4, and Figure 5 read tables from `exploratory/data/` directly.

Knit each notebook from `manuscript/scripts/`. The submitted panel files are in [`manuscript/figures/panels/`](manuscript/figures/panels/). Earlier exports remain in `manuscript/figures/` and `exploratory/figures/`.

| Notebook | Submitted panels |
| --- | --- |
| [`manuscript/scripts/figure_1_manuscript.Rmd`](manuscript/scripts/figure_1_manuscript.Rmd) | Figure 1B–D. Writes Supplementary Table S1. |
| [`manuscript/scripts/figure_2_manuscript.Rmd`](manuscript/scripts/figure_2_manuscript.Rmd) | Figure 2B–F. Writes Supplementary Table S2. |
| [`manuscript/scripts/figure_3_manuscript.Rmd`](manuscript/scripts/figure_3_manuscript.Rmd) | Figure 3A and 3D. Writes Supplementary Table S4. |
| [`manuscript/scripts/mimic_gavaged-sample_barplots.Rmd`](manuscript/scripts/mimic_gavaged-sample_barplots.Rmd) | Figure 3B. |
| [`manuscript/scripts/MetaG_16S_PCoA_LN.Rmd`](manuscript/scripts/MetaG_16S_PCoA_LN.Rmd) | Figure 3C. |
| [`manuscript/scripts/figure_4_manuscript.Rmd`](manuscript/scripts/figure_4_manuscript.Rmd) | Figure 4A–C and Figure 5B. |
| [`manuscript/scripts/IHC_mimic18.Rmd`](manuscript/scripts/IHC_mimic18.Rmd) | Figure 4G. |
| [`manuscript/scripts/metabolomics_scfa_manuscript.Rmd`](manuscript/scripts/metabolomics_scfa_manuscript.Rmd) | Figure 5C. |
| [`manuscript/scripts/metabolomics.Rmd`](manuscript/scripts/metabolomics.Rmd) | Figure 5D and Supplementary Figures S1–S3. |
| [`manuscript/scripts/BO_BM_vs_AR_KEGG_analysis.Rmd`](manuscript/scripts/BO_BM_vs_AR_KEGG_analysis.Rmd) | Figure 5E and 5F. |
| [`manuscript/scripts/Phylogenetic_relatedness_tree.Rmd`](manuscript/scripts/Phylogenetic_relatedness_tree.Rmd) | Figure 5A. |

Figures 1–3, and the three short-chain fatty acids in Figure 5C, have a shortened notebook that drops layouts that were not submitted. The remaining panel notebooks were copied into `manuscript/scripts/` from `exploratory/scripts/`. The originals are still in the repository.

| Manuscript-facing copy | Notebook it was copied from |
| --- | --- |
| `manuscript/scripts/figure_1_manuscript.Rmd` | [`manuscript/scripts/figure_1.Rmd`](manuscript/scripts/figure_1.Rmd) |
| `manuscript/scripts/figure_2_manuscript.Rmd` | [`manuscript/scripts/figure_2.Rmd`](manuscript/scripts/figure_2.Rmd) |
| `manuscript/scripts/figure_3_manuscript.Rmd` | [`manuscript/scripts/figure_3.Rmd`](manuscript/scripts/figure_3.Rmd) |
| `manuscript/scripts/figure_4_manuscript.Rmd` | [`exploratory/scripts/Fig3E-F_mim18-19_volume-analyses.Rmd`](exploratory/scripts/Fig3E-F_mim18-19_volume-analyses.Rmd) and [`exploratory/scripts/mimic_gavaged-sample_barplots.Rmd`](exploratory/scripts/mimic_gavaged-sample_barplots.Rmd) |
| `manuscript/scripts/metabolomics_scfa_manuscript.Rmd` | [`exploratory/scripts/metabolomics.Rmd`](exploratory/scripts/metabolomics.Rmd), Figure 5C only |
| `manuscript/scripts/IHC_mimic18.Rmd` | [`exploratory/scripts/IHC_mimic18.Rmd`](exploratory/scripts/IHC_mimic18.Rmd) |
| `manuscript/scripts/Phylogenetic_relatedness_tree.Rmd` | [`exploratory/scripts/Phylogenetic_relatedness_tree.Rmd`](exploratory/scripts/Phylogenetic_relatedness_tree.Rmd) |
| `manuscript/scripts/metabolomics.Rmd` | [`exploratory/scripts/metabolomics.Rmd`](exploratory/scripts/metabolomics.Rmd) |
| `manuscript/scripts/BO_BM_vs_AR_KEGG_analysis.Rmd` | [`exploratory/scripts/BO_BM_vs_AR_KEGG_analysis.Rmd`](exploratory/scripts/BO_BM_vs_AR_KEGG_analysis.Rmd) |
| `manuscript/scripts/mimic_gavaged-sample_barplots.Rmd` | [`exploratory/scripts/mimic_gavaged-sample_barplots.Rmd`](exploratory/scripts/mimic_gavaged-sample_barplots.Rmd) |

Model functions live in `manuscript/scripts/analysis-scripts/`. The packages those functions attach are listed in [`manuscript/scripts/analysis-scripts/packages.R`](manuscript/scripts/analysis-scripts/packages.R). The code is released under the [MIT license](LICENSE).

## Where each panel is

Schematics and microscopy were assembled outside these notebooks: Figure 1A, Figure 2A, the antibiotics bar and mouse icons on Figure 3A, and the histology in Figure 4D–F.

| Panel | What it shows | Where it is made | File |
| --- | --- | --- | --- |
| Figure 1B | Rat 16S ordination, with distance to the diet centroid inset in the submitted panel. | [`figure_1_manuscript.Rmd`](manuscript/scripts/figure_1_manuscript.Rmd) draws both pieces. The panel file is the submitted ordination, copied from [`Fig1B-dmm21.svg`](manuscript/figures/Fig1B-dmm21.svg). Knitting the notebook writes a different ordination into that same path. | [`fig1B_rat-16S-pca.svg`](manuscript/figures/panels/fig1B_rat-16S-pca.svg), [`fig1B_rat-distance-to-centroid.svg`](manuscript/figures/panels/fig1B_rat-distance-to-centroid.svg) |
| Figure 1C | Taxa that differ by black-raspberry diet, colored by rank. | `figure_1_manuscript.Rmd` | [`fig1C_rat-taxon-volcano.svg`](manuscript/figures/panels/fig1C_rat-taxon-volcano.svg) |
| Figure 1D | Effect sizes for taxa with adjusted *p* < 0.05. | `figure_1_manuscript.Rmd` | [`fig1D_rat-effect-sizes.svg`](manuscript/figures/panels/fig1D_rat-effect-sizes.svg) |
| Figure 2B | Phylum composition at the four stool timepoints. | `figure_2_manuscript.Rmd` | [`fig2B_phylum-stacked-bars.svg`](manuscript/figures/panels/fig2B_phylum-stacked-bars.svg) |
| Figure 2C | Mixed-model volcano of taxa that change after nectar. | `figure_2_manuscript.Rmd` | [`fig2C_bewell-taxon-volcano.svg`](manuscript/figures/panels/fig2C_bewell-taxon-volcano.svg) |
| Figure 2D | Effect sizes. *Roseburia* sp. CAG 309 is the largest. | The panel file is the submitted bar chart, copied from [`2D.svg`](manuscript/figures/2D.svg), with the legend inside the panel. [`figure_2_manuscript.Rmd`](manuscript/scripts/figure_2_manuscript.Rmd) writes the same analysis with the legend outside, into that same path. | [`fig2D_bewell-effect-sizes.svg`](manuscript/figures/panels/fig2D_bewell-effect-sizes.svg) |
| Figure 2E | Responder-signature ordination. Five published immunotherapy cohorts, with BE WELL samples overlaid. Adonis *p* = 0.007. | `figure_2_manuscript.Rmd` | [`fig2E_responder-signature-pca.svg`](manuscript/figures/panels/fig2E_responder-signature-pca.svg) |
| Figure 2F | Pre-to-post change in distance to the responder and non-responder centroids. | `figure_2_manuscript.Rmd` | [`fig2F_change-in-distance-to-centroid.svg`](manuscript/figures/panels/fig2F_change-in-distance-to-centroid.svg) |
| Figure 3A | Mimic 10 tumor volume after pre-nectar versus post-nectar stool, with or without anti-PD-1. | `figure_3_manuscript.Rmd` | [`fig3A_mimic10-tumor-volume.svg`](manuscript/figures/panels/fig3A_mimic10-tumor-volume.svg) |
| Figure 3B | Lachnospiraceae in participants 102, 55, 68, 79, 84, and 85 before and after nectar. The PDF replaces the `rB`/`tB` axis labels with symbols. | [`manuscript/scripts/mimic_gavaged-sample_barplots.Rmd`](manuscript/scripts/mimic_gavaged-sample_barplots.Rmd) | [`fig3B_lachnospiraceae-by-participant.svg`](manuscript/figures/panels/fig3B_lachnospiraceae-by-participant.svg) |
| Figure 3C | Engraftment for donor 85. The submitted panel pairs the 16S ordination (PC1 52.2%, PC2 29.9%) with distance to the gavage. | The ordination is [`MetaG_16S_PCoA_LN.Rmd`](manuscript/scripts/MetaG_16S_PCoA_LN.Rmd), saved as [`supplement-pcoa-85rB.svg`](manuscript/figures/supplement-pcoa-85rB.svg). The distance boxplot is [`combo.85v2.svg`](manuscript/figures/combo.85v2.svg). Those distances are calculated in [`exploratory/scripts/Bray-Curtis-16S.Rmd`](exploratory/scripts/Bray-Curtis-16S.Rmd). | [`fig3C_engraftment-pcoa-donor85-16S.svg`](manuscript/figures/panels/fig3C_engraftment-pcoa-donor85-16S.svg), [`fig3C_engraftment-distance-donor85.svg`](manuscript/figures/panels/fig3C_engraftment-distance-donor85.svg) |
| Figure 3D | Linear mixed-model estimates for anti-PD-1 and gavage. Supplementary Table S4 is this model table. | `figure_3_manuscript.Rmd` | [`fig3D_lme-heatmap.svg`](manuscript/figures/panels/fig3D_lme-heatmap.svg) |
| Figure 4A | Lachnospiraceae in participant 85. | [`manuscript/scripts/figure_4_manuscript.Rmd`](manuscript/scripts/figure_4_manuscript.Rmd) | [`fig4A_participant85-lachnospiraceae.svg`](manuscript/figures/panels/fig4A_participant85-lachnospiraceae.svg) |
| Figure 4B | Tumor volume after participant 85 stool with or without *B. obeum*. | [`manuscript/scripts/figure_4_manuscript.Rmd`](manuscript/scripts/figure_4_manuscript.Rmd) | [`fig4B_blautia-tumor-volume.svg`](manuscript/figures/panels/fig4B_blautia-tumor-volume.svg) |
| Figure 4C | Fraction of mice remaining tumor-free. | [`manuscript/scripts/figure_4_manuscript.Rmd`](manuscript/scripts/figure_4_manuscript.Rmd) | [`fig4C_blautia-tumor-free.svg`](manuscript/figures/panels/fig4C_blautia-tumor-free.svg) |
| Figure 4G | Colon CD11c-positive cells per mm². | [`manuscript/scripts/IHC_mimic18.Rmd`](manuscript/scripts/IHC_mimic18.Rmd) | [`fig4G_cd11c-colon.svg`](manuscript/figures/panels/fig4G_cd11c-colon.svg) |
| Figure 5A | Lachnospiraceae tree with *A. rectalis*, *B. obeum*, and *B. massiliensis* marked. | [`manuscript/scripts/Phylogenetic_relatedness_tree.Rmd`](manuscript/scripts/Phylogenetic_relatedness_tree.Rmd) | The notebook writes [`fig5A_lachnospiraceae-tree.svg`](manuscript/figures/panels/fig5A_lachnospiraceae-tree.svg) after the GTDB release 232 files are downloaded into `exploratory/data/`. Links are in the notebook and under Data below. |
| Figure 5B | Tumor volume after *A. rectalis*, *B. obeum*, or *B. massiliensis*. | [`manuscript/scripts/figure_4_manuscript.Rmd`](manuscript/scripts/figure_4_manuscript.Rmd) | [`fig5B_three-strain-tumor-volume.svg`](manuscript/figures/panels/fig5B_three-strain-tumor-volume.svg) |
| Figure 5C | Butyrate, heptanoate, and valerate. | [`manuscript/scripts/metabolomics_scfa_manuscript.Rmd`](manuscript/scripts/metabolomics_scfa_manuscript.Rmd) | [`fig5C_scfa-butyrate-heptanoate-valerate.svg`](manuscript/figures/panels/fig5C_scfa-butyrate-heptanoate-valerate.svg) |
| Figure 5D | L(−)-carnitine. | [`manuscript/scripts/metabolomics.Rmd`](manuscript/scripts/metabolomics.Rmd) | [`fig5D_l-carnitine.svg`](manuscript/figures/panels/fig5D_l-carnitine.svg) |
| Figure 5E | KEGG orthologs shared by *B. obeum* and *B. massiliensis* but not *A. rectalis*. | [`manuscript/scripts/BO_BM_vs_AR_KEGG_analysis.Rmd`](manuscript/scripts/BO_BM_vs_AR_KEGG_analysis.Rmd) | [`fig5E_shared-ko-upset.pdf`](manuscript/figures/panels/fig5E_shared-ko-upset.pdf) |
| Figure 5F | Enriched pathways among those shared orthologs. | [`manuscript/scripts/BO_BM_vs_AR_KEGG_analysis.Rmd`](manuscript/scripts/BO_BM_vs_AR_KEGG_analysis.Rmd) | [`fig5F_kegg-enrichment.svg`](manuscript/figures/panels/fig5F_kegg-enrichment.svg) |
| Supplementary Figure S1 | All measured short-chain fatty acids. | [`manuscript/scripts/metabolomics.Rmd`](manuscript/scripts/metabolomics.Rmd) | [`s1_scfa-all.svg`](manuscript/figures/panels/supplementary/s1_scfa-all.svg) |
| Supplementary Figure S2 | Fecal indoles, panels A–F. | [`manuscript/scripts/metabolomics.Rmd`](manuscript/scripts/metabolomics.Rmd) | [`supplementary/`](manuscript/figures/panels/supplementary/) |
| Supplementary Figure S3 | Blood dihydroxyindole and trans-3-indoleacrylic acid. | [`manuscript/scripts/metabolomics.Rmd`](manuscript/scripts/metabolomics.Rmd) | [`s3A_blood-dihydroxyindole.svg`](manuscript/figures/panels/supplementary/s3A_blood-dihydroxyindole.svg), [`s3B_blood-trans-3-indoleacrylic-acid.svg`](manuscript/figures/panels/supplementary/s3B_blood-trans-3-indoleacrylic-acid.svg) |

The same engraftment ordination is saved for the other donors in [`manuscript/figures/panels/fig3C_other-donors/`](manuscript/figures/panels/fig3C_other-donors/). `rB` is 16S and `tB` is metagenomic. Donor 84 has a 16S PNG only (`manuscript/figures/supplement-pcoa-84rB.png`). Those files are not a numbered supplementary figure.

### Supplementary tables

| Table | Contents | File |
| --- | --- | --- |
| Supplementary Table S1 | Rat differential-abundance results (Figure 1C) | [`manuscript/tables/Supp-Table-S1_rat-volcano.csv`](manuscript/tables/Supp-Table-S1_rat-volcano.csv) |
| Supplementary Table S2 | BE WELL mixed-model results (Figure 2C) | [`manuscript/tables/Supp-Table-S2_bewell-volcano.csv`](manuscript/tables/Supp-Table-S2_bewell-volcano.csv) |
| Supplementary Table S4 | Mouse longitudinal-model estimates (Figure 3D) | [`manuscript/tables/Supp-Table-S4_model-summary-values.csv`](manuscript/tables/Supp-Table-S4_model-summary-values.csv) |

Supplementary Table S3, the responder-signature cohort table, is not a file in this repository. The ordination inputs are `manuscript/data/BEWELL/respondersig-PLSDA-RA.csv` and `manuscript/data/BEWELL/respondersig-response.csv`.

## Repository layout

- `manuscript/figures/panels/` — copies named for the submitted panels
- `manuscript/scripts/figure_*_manuscript.Rmd` — one plotting path for Figures 1–3
- `manuscript/scripts/figure_1.Rmd` through `figure_4.Rmd` — original notebooks, including layouts that were not used
- `manuscript/scripts/analysis-scripts/` — functions that build the model objects
- `manuscript/scripts/prepare-figure-data.R` — runs those functions and saves the `.rda` files
- `manuscript/data/` — rat 16S, BE WELL tables used here, mouse tumor measurements, and the saved model objects
- `exploratory/` — draft notebooks, metabolomics, KEGG, immunohistochemistry, the phylogeny, and analyses that did not go into the paper. Panel notebooks copied into `manuscript/scripts/` still have their originals here.

## Data

Tables required to draw the panels are in `manuscript/data/` and `exploratory/data/`. BE WELL sequencing reads and the clinical export are not in this repository. Read-level files and the trial metadata are described in [spakowiczlab/bewell](https://github.com/spakowiczlab/bewell).

Figure 5A needs the bacterial reference tree from [GTDB release 232](https://data.gtdb.ecogenomic.org/releases/release232/232.0/) (15 April 2026). Download these three files into `exploratory/data/` and rename them to the names the notebook reads. The metadata file is 276 MB, so it is not stored in this repository.

| Save as | Download |
| --- | --- |
| `bac120.tree.gz` | [bac120_r232.tree.gz](https://data.gtdb.ecogenomic.org/releases/release232/232.0/bac120_r232.tree.gz) (2.3 MB) |
| `bac120_taxonomy.tsv.gz` | [bac120_taxonomy_r232.tsv.gz](https://data.gtdb.ecogenomic.org/releases/release232/232.0/bac120_taxonomy_r232.tsv.gz) (9.4 MB) |
| `bac120_metadata.tsv.gz` | [bac120_metadata_r232.tsv.gz](https://data.gtdb.ecogenomic.org/releases/release232/232.0/bac120_metadata_r232.tsv.gz) (276 MB) |

#' Fraction of mice that were tumor-free after participant-85 stool.
#'
#' @param allexp Tumor measurements for every mimic experiment.
#' @return One row per microbiome sample and treatment in the 85v1
#'   experiments. \code{frac.0} is the share of mice whose final tumor
#'   volume was zero.
blautiaResponse <- function(allexp){
  # Calculating complete response in each experiment
  tmp <- allexp %>%
    mutate(treatment=if_else(grepl("PD", treatment), 
                             true = "Anti-PD1", 
                             false = "IgG")) %>%
    group_by(unique.mouse.id) %>%
    filter(days.from.injection == max(days.from.injection)) %>%
    ungroup() %>%
    mutate(new.group = paste0(microbiome.sample, treatment)) %>%
    mutate(tumor.size.is.0 = if_else(tumor.volume > 0, 
                                     true = 0, 
                                     false = 1)) %>%
    group_by(new.group, experiment, microbiome.sample, treatment) %>%
    summarize(frac.0 = sum(tumor.size.is.0) /length(tumor.size.is.0)) %>%
    mutate(brb = if_else(grepl("v1|v3", 
                               microbiome.sample), 
                         true = "preBRB",
                         false = if_else(grepl("v2|v4",
                                               microbiome.sample),
                                         true = "postBRB",
                                         false = microbiome.sample))) %>%
    mutate(brb = fct_relevel(brb, "preBRB"))
  
  # Filtering to mouse with treatments we want
  
  blautia.group <- tmp %>%
    filter(grepl("85v1", microbiome.sample)) %>%
    mutate(gavage = gsub("HONC60-", "", microbiome.sample))
  return(blautia.group)
}


#' Endpoint tumor volumes for the mimic boxplots.
#'
#' Keeps each mouse's last measurement after day 10 and labels the BE WELL
#' donor experiments.
#'
#' @param allexp Tumor measurements for every mimic experiment.
#' @return A named list: \code{bewell.filt} is the donor-labeled endpoint
#'   table, and \code{labelled.patients} carries the short donor labels used
#'   on the plot.
mimicBoxPrep <- function(allexp){
  processed.data <- allexp %>%
    mutate(treatment = fct_relevel(treatment, "IgG")) %>%
    mutate(treatment.group = paste(treatment, microbiome.sample, sep = " x ")) %>%
    mutate(treatment = as.character(treatment)) %>%
    mutate(max.days = max(days.from.injection), .by = c(unique.mouse.id, experiment)) %>%
    filter(days.from.injection == max.days & days.from.injection > 10) %>% # Need to confirm this is right, to exclude mice that died very early 
    mutate(experiment = fct_relevel(experiment, "mimic10","mimic11","mimic12", "mimic13", after = 9)) %>%
    mutate(treatment = if_else(grepl("PD1", treatment),
                               true = "Anti-PD1",
                               false = treatment)) %>%
    mutate(gavage = if_else(grepl("v1|v3", microbiome.sample),
                            true = "Pre-BRB",
                            false = if_else(grepl("v2|v4", microbiome.sample),
                                            true = "Post-BRB",
                                            false = "other")))
  
  bewell.filter <- processed.data %>%
    mutate(patient = case_when(experiment %in% c("mimic1","mimic6","mimic7") ~ "HONC60-55: Random Sample",
                                experiment == "mimic5" ~ "HONC60-102",
                                experiment == "mimic10" ~ "HONC60-68: Roseburia + Blautia",
                                experiment == "mimic11" ~ "HONC60-79: Lachnospira",
                                experiment == "mimic12" ~ "HONC60-85: Blautia",
                                experiment == "mimic13" ~ "HONC60-84: Blautia")) %>%
    filter(!is.na(patient)) %>%
    mutate(gavage = ifelse(experiment == "mimic11", 
                           ifelse(grepl("v2", microbiome.sample),
                                  "Post-Placebo",
                                  "Post-BRB"),
                           gavage)
           ) %>%
    mutate(treatment = fct_relevel(treatment, "IgG")) %>%
    mutate(gavage = fct_relevel(gavage, "Pre-BRB", "Post-Placebo"))
    
    labelpats <- 
      processed.data %>%
      mutate(patient = case_when(experiment %in% c("mimic1","mimic6","mimic7") ~ "55",
                                 experiment == "mimic5" ~ "10",
                                 experiment == "mimic10" ~ "68",
                                 .default = "other"))
    
    mim.boxdat <- list(bewell.filter, labelpats)
    names(mim.boxdat) <- c("bewell.filt", "labelled.patients")
    return(mim.boxdat)
}

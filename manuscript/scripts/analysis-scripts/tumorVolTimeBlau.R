tumorVolTimeBlau <- function(allexp){
  tmp <- allexp %>%filter(experiment == "mimic18" | experiment == "mimic19") %>% 
    mutate(supplement = if_else(grepl("Blautia", microbiome.sample),
                                true = "Blautia",
                                false = "Normal"),
           supplement = fct_relevel(supplement, "Normal"),
           microbiome.sample = ifelse(grepl("Blautia",microbiome.sample),
                                      "85v1 + Blautia",
                                      "85v1"))%>%
    mutate(treatment.group = paste(treatment, microbiome.sample, sep = " x ")) %>%
    group_by(treatment.group, days.from.injection) %>%
    summarize(mean = mean(tumor.volume),
              sd = sd(tumor.volume)) %>%
    ungroup() %>%
    mutate(lwr = mean - sd,
           upr = mean + sd) %>%
    mutate(lwr = if_else(lwr < 0, 0, lwr)) %>%
    mutate(Supplement = if_else(grepl("Blautia", treatment.group),
                                true = "Blautia",
                                false = "Normal"),
           Treatment = if_else(grepl("Anti", treatment.group),
                               true = "Anti-PD1",
                               false = "IgG")) %>%
    mutate(Supplement = fct_relevel(Supplement, c("Blautia")))
  
  
  return(tmp)
}

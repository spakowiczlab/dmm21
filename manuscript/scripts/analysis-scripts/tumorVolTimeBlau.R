tumorVolTimeBlau <- function(allexp){
  tmp <- allexp %>%
    filter(experiment == "mimic18" | experiment == "mimic19") %>% 
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
  
  modelin <- allexp %>%
    mutate(gavage = if_else(grepl("v1|v3", microbiome.sample),
                            true = "Pre-BRB",
                            false = if_else(grepl("v2|v4", microbiome.sample),
                                            true = "Post-BRB",
                                            false = "other"))) %>%
    mutate(gavage = fct_relevel(gavage, "Pre-BRB")) %>%
    mutate(treatment = fct_relevel(treatment, "IgG")) %>%
    mutate(days2 = days.from.injection^2) %>%
    filter(experiment == "mimic18" | experiment == "mimic19") %>% 
    mutate(supplement = if_else(grepl("Blautia", microbiome.sample),
                                true = "Blautia",
                                false = "Normal"),
           supplement = fct_relevel(supplement, "Normal"),
           microbiome.sample = ifelse(grepl("Blautia",microbiome.sample),
                                      "85v1 + Blautia",
                                      "85v1"))
  
  m.18.19 <- lmer(tumor.volume ~ days.from.injection + days2 * treatment * supplement + (1|unique.mouse.id) + experiment,
                  data = modelin)
  
  # AIC(m.18.19)
  # summary(m.18.19)
  
  processModel <- function(model) {
    model %>%
      tidy() %>%
      mutate(abs.estimate = abs(estimate),
             plus.minus = ifelse(estimate > 0, "p", "n"),
             log.estimate = log10(abs.estimate)) %>%
      mutate(log.estimate = ifelse(plus.minus == "n", 
                                   -1*log.estimate, 
                                   log.estimate),
             log.std.error = log10(std.error),
             log.std.error = abs(log.std.error)) %>%
      mutate(sig.flag = ifelse(p.value < 0.05, "S", "NS"),
             conf.low = estimate - std.error,
             conf.high = estimate + std.error,
             log.conf.low = log.estimate - log.std.error,
             log.conf.high = log.estimate + log.std.error,
             ci95.low = estimate - (1.96 * std.error),
             ci95.high = estimate + (1.96 * std.error)) %>% 
      filter(is.na(group)) %>%
      filter(term != "(Intercept)")
  }
  
  data.1819 <- processModel(m.18.19) %>%
    mutate(experiment = "mimic18,19",
           trial = "BEWELL",
           `sample ID` = "HONC60-85v1",
           hypothesis = "Blautia Supplementation",
           `Combined ID` = "Blautia Supplementation (85v1)")
  
  outs <- list(tmp, data.1819)
  names(outs) <- c("plotdat", "modelres")
  return(outs)
}

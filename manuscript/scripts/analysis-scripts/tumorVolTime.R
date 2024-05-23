tumorVolTime <- function(allexp){
  tmp <- allexp %>%
    filter(experiment == "mimic10") %>%
    mutate(treatment.group = paste(treatment, microbiome.sample, sep = " x ")) %>%
    group_by(treatment.group, days.from.injection) %>%
    summarize(mean = mean(tumor.volume),
              sd = sd(tumor.volume)) %>%
    ungroup() %>%
    mutate(lwr = mean - sd,
           upr = mean + sd) %>%
    mutate(lwr = if_else(lwr < 0, 0, lwr)) 
  
  return(tmp)
}
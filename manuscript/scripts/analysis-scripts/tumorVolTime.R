#' Mean tumor volume over time in mimic 10.
#'
#' @param allexp Tumor measurements for every mimic experiment, including
#'   \code{experiment}, \code{treatment}, \code{microbiome.sample},
#'   \code{days.from.injection}, and \code{tumor.volume}.
#' @return Mean volume and a mean-plus-or-minus-sd ribbon for each treatment
#'   group and day. The lower ribbon edge is truncated at zero.
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
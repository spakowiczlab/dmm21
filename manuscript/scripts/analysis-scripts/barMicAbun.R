#' Blautia obeum abundance in BE WELL participants 84 and 102.
#'
#' @param metout Long relative-abundance table with taxonomy, subject, and
#'   visit columns.
#' @return Abundance of \code{s__Blautia_obeum} at each visit, labeled
#'   pre/post placebo or pre/post black raspberry.
barMicAbun <- function(metout){
  tmp <- metout %>%
    select(-Alternative.Tax, -TaxNum) %>%
    pivot_wider(names_from = Taxonomy, values_from = RelAbun, values_fill = 0) %>%
    pivot_longer(-c("id","Subject.ID", "Subject.Number",  "placebo", "variable", "sample"), names_to = "Taxonomy", values_to = "RelAbun") %>%
    filter(grepl("s__Blautia_obeum", Taxonomy)) %>% # Which microbes - can be added as argument
    filter(Subject.Number %in% c(84,102)) %>% # Which patients - could be an argument
    mutate(timepoint = case_when(variable == "rB" ~ "Pre-BRB",
                                 variable == "tB" ~ "Post-BRB",
                                 variable == "rP" ~ "Pre-Placebo",
                                 variable == "tP" ~ "Post-Placebo"))
  
  return(tmp)
    
}

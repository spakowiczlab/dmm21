stackedBarBEWELL <- function(exora, nphyl){
  
  taxa <- exora %>% 
    separate(Taxonomy, c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus"), "\\|")

  exora.p <- taxa %>%
    filter(!is.na(Phylum) & is.na(Class))
  
  large.phyls <- exora.p %>% 
    group_by(Phylum) %>%
    summarize(median.ra = median(RelAbun)) %>%
    arrange(desc(median.ra)) %>%
    mutate(x = row_number()) %>%
    dplyr::filter(x <= nphyl)
  large.phyls <- large.phyls$Phylum
  
  tmp <- exora.p %>% 
    filter(Phylum == large.phyls[1]) %>%
    arrange(desc(RelAbun))
  sampord.orter <- tmp$sample
  
  vars <- bewell.tax %>% 
    dplyr::select(sample, variable) %>% 
    distinct()
  
  exora.p.hist <- vars %>%
    right_join(exora.p) %>%
    mutate(Phylum = ifelse(Phylum %in% large.phyls, Phylum, "Other"),
           Phylum = gsub("^p__", "", Phylum),
           sample = fct_relevel(sample, sampord.orter),
           timepoint = case_when(variable == "rB" ~ "Pre-BRB",
                                 variable == "tB" ~ "Post-BRB",
                                 variable == "rP" ~ "Pre-Placebo",
                                 variable == "tP" ~ "Post-Placebo"))
  
  return(exora.p.hist)
}

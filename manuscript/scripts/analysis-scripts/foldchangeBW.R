foldchangeBW <- function(mics){
  prepareFoldChangeLev <- function(lev.in, lev.out){
    
    if(!is.na(lev.out)){
      tmp.lev <- mics %>%
        filter(grepl(lev.in, Taxonomy) & !grepl(lev.out, Taxonomy))
    }
    else {
      tmp.lev <- mics %>%
        filter(grepl(lev.in, Taxonomy))
    }
    
    fc.prep <- tmp.lev %>%
      mutate(term = str_remove(Taxonomy, ".*\\|"),
             brb.code = ifelse(variable == "tB", "treatment", "control")) %>%
      select(sample, term, RelAbun, brb.code) %>%
      group_by(sample, term, brb.code) %>%
      summarise(RelAbun = sum(RelAbun)) %>%
      ungroup() %>%
      pivot_wider(names_from = "term", values_from = "RelAbun", values_fill = 0) %>%
      pivot_longer(-c("sample", "brb.code"), names_to = "term", values_to = "RelAbun") %>%
      group_by(term, brb.code) %>%
      summarise(mean.ra = mean(RelAbun)) %>%
      pivot_wider(names_from = "brb.code", values_from = "mean.ra") %>%
      mutate(l2fc = log(treatment/control),
             l2fc = case_when(!l2fc %in% c(Inf, -Inf) ~ l2fc)) %>%
      select(term, l2fc)
    
    return(fc.prep)
  }
  
  set.levin <- c("k__", "p__", "c__", "o__", "f__", "g__", "s__")
  set.levout <- c(set.levin[2:6], NA)
  
  
  points.foldchange <- lapply(1:6, function(x) prepareFoldChangeLev(set.levin[x], set.levout[x])) %>%
    bind_rows()
  
  return(points.foldchange)
}

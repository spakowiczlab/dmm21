modelBW <- function(relabun){
  capture.models.univ <- function(outcome, lfun, mics, modin){
    mods.list <- lapply(mics, function(x)  try({glm(as.formula(paste0(outcome, " ~ ", x)), family = lfun, data = modin) %>% tidy()}))
    #glm: generalized linear model
    #modin: model input                    
    mods.list.clean <- list.clean(mods.list, function(x) is.null(x))
    mods.df <- bind_rows(mods.list.clean)
    return(mods.df)
  }
  #list.clean: removes all elements that are TRUE
  #is.null function: to remove missing values
  
  format_and_model <- function(tmp){
    tmp.mics <- colnames(tmp)[-1]
    tmp.form <- tmp %>%
      mutate(berry.group = ifelse(grepl("tB",sample), 1, 0)) #ifelse: TRUE if 1, FLASE if 0
    #grepl: check somethign by comparing it across a pattern (pattern, vaeiable)
    res <- capture.models.univ("berry.group", "binomial", tmp.mics, tmp.form) %>%
      filter(term !="(Intercept)")
    return(res)
  }
  
  toWideList <- function(longabun){
    get.tlev <- function(lev.in, lev.out){
      tmp.lev <- longabun %>%
        mutate(sample = paste(Subject.ID, variable, sep = "_")) %>%
        select(sample, Taxonomy, RelAbun) %>%
        filter(grepl(lev.in, Taxonomy) & !grepl(lev.out, Taxonomy)) %>%
        mutate(Taxonomy = gsub(".*\\|", "", Taxonomy))
      
      tmp.wide <- tmp.lev %>%
        pivot_wider(names_from = Taxonomy, values_from = RelAbun, values_fill = 0)
    }
    tlev1 <- c("k__", "p__", "c__", "o__", "f__", "g__", "s__")
    tlev2 <- c("p__", "c__", "o__", "f__", "g__", "s__", "^any")
    
    df.list <- lapply(1:7, function(x) get.tlev(tlev1[x], tlev2[x]))
    return(df.list)
  }
  
  all_tax_levs <- toWideList(relabun)
  all_mod_res <- lapply(all_tax_levs, format_and_model) %>%
    bind_rows() %>%
    arrange(p.value)
  
  return(all_mod_res)
}

formatRBgroups <- function(){
  groups.xl <- read_xlsx("../data/rberry/groups.xlsx")
  groups.id <- read.csv("../data/rberry/counts-per-sample.csv")
  
  groups.file <- rownames_to_column(groups.xl,var="X")
  groups.file$X <- as.integer(groups.file$X)
  groups.join <- inner_join(groups.id,groups.file,"X")
  
  groups.filter <-
    groups.join %>%
    filter((group == "nmba")|(group == "brb"))
  
  # Need to remove RB013, which has zeroes for all counts
  
  groups.filter2 <-
    groups.filter %>%
    slice(-c(8))
  
  groups.object <-
    groups.filter2 %>%
    select(sample,group)
  
  groups.object$group <- as.factor(groups.object$group)
  groups.object$sample <- as.factor(groups.object$sample)
  
  # Have to relevel the groups so that DESeq doesn't read them in the wrong order
  
  groups.object2 <-
    groups.object %>%
    mutate(group=fct_relevel(group,"nmba"))
  
  return(groups.object2)
}

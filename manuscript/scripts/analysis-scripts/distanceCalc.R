distanceCalc <- function(seqtab, meta){
  dist.in <- seqtab %>%
    as.data.frame() %>%
    rownames_to_column(var = "sample") %>%
    filter(sample %in% meta$sample) %>%
    arrange(sample) %>%
    column_to_rownames(var = "sample")
  meta <- meta %>%
    mutate(sample = as.character(sample)) %>%
    arrange(sample) %>%
    mutate(GroupID = ifelse(group == "brb", "Black Raspberry", "Control"))
  group <- as.vector(meta$GroupID)
  
  set.seed(528934)
  adon.results <- adonis2(dist.in ~ group, method="euclidean",perm=999)
  print(adon.results)
  
  dist <- vegdist(dist.in, method = "euclidean")
  mod <- betadisper(dist, group, type = "centroid")
  # median is deafult 
  # mod2 <- betadisper(dist, group)
  
  c.dist <- as.data.frame(mod$distances) %>%
    rownames_to_column("sample") %>%
    left_join(meta) %>%
    dplyr::rename(Distance = `mod$distances`) %>%
    mutate(adonis.p.val = adon.results$`Pr(>F)`[1])
  
  return(c.dist)
  
}
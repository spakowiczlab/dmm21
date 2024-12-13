respondersigDist <- function(x, meta){
  dist.in <- x %>%
    filter(sample %in% meta$sample) %>%
    arrange(sample) %>%
    column_to_rownames(var = "sample")
  meta <- meta %>%
    arrange(sample)
  
  group <- as.vector(meta$response)
  
  set.seed(528934)
  adon.results <- adonis2(dist.in ~ group, method="euclidean",perm=999)
  print(adon.results)
  
  # get distance matrix 
  dist <- vegdist(dist.in, method = "euclidean")
  
  # distance to every group centroid, filter to dist to Responder centroid
  c.dist <- usedist::dist_to_centroids(dist, group) %>%
    #filter(CentroidGroup == "Responder") %>%
    dplyr::rename("sample" = Item) %>%
    mutate(R2 = adon.results$R2[1])
  
  c.dist <- c.dist %>%
    left_join(respondersig.response) %>%
    filter(dataset == "BEWELL") %>%
    mutate(Group = case_when(response == "rP" ~ "Pre-Placebo",
                             response == "tP" ~ "Post-Placebo",
                             response == "rB" ~ "Pre-BRB",
                             response == "tB" ~ "Post-BRB"))
  
  c.dist$Group <- factor(c.dist$Group, levels=c("Pre-Placebo", "Post-Placebo", "Pre-BRB", "Post-BRB"))
  
  return(c.dist)
  
}


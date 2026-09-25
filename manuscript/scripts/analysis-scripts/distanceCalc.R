#' Distance of each rat sample to its diet centroid.
#'
#' Runs a Euclidean adonis2 test of diet, then returns the distance of each
#' sample to the centroid of its group.
#'
#' @param seqtab Sample-by-taxon count matrix.
#' @param meta Sample metadata with \code{sample} and \code{group}
#'   (\code{brb} or \code{nmba}).
#' @return Per-sample centroid distances and the adonis p-value.
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
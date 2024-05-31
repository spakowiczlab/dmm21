seqToPCAplot <- function(seqtab, meta){
  pca.in <- seqtab %>%
    as.data.frame() %>%
    rownames_to_column(var = "sample") %>%
    filter(sample %in% meta$sample) %>%
    arrange(sample) %>%
    column_to_rownames(var = "sample") %>%
    as.matrix()
  
  meta <- meta %>%
    mutate(sample = as.character(sample)) %>%
    arrange(sample) %>%
    mutate(GroupID = ifelse(group == "brb", "Black Raspberry", "Control"))
  
  pca.res <- prcomp(pca.in)
  
  outs <- list(pca.res, meta)
  names(outs) <- c("PCA", "GroupLabs")
  
  return(outs)
}

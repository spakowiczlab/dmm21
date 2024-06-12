preparePhyloDat <- function(metout, modres, sigcut){
  
  # Get Lachno tax ids
  allspecs <- metout %>%
    select(Taxonomy, TaxNum) %>%
    filter(grepl("s__", Taxonomy)) %>%
    distinct()
  
  allspecs.remtax <- str_remove(allspecs$Taxonomy,".*\\|")
  alltax <- allspecs$TaxNum
  
  lachno.members <- unique(subset(allspecs$Taxonomy, grepl("f__Lachno", allspecs$Taxonomy)))
  
  lachno.remtax <- str_remove(lachno.members,".*\\|")
  lachno.taxids <- unique(subset(allspecs$TaxNum, grepl("f__Lachno", allspecs$Taxonomy)))
  
  # Which species were significant?
  brb.enriched <- modres %>%
    filter(estimate > 0 &
             p.value < sigcut &
             term %in% allspecs.remtax) %>%
    mutate(lachno = ifelse(term %in% lachno.remtax, "Lachno", "Not Lachno"))
  
  brb.enriched.taxids <- metout %>%
    dplyr::select(Taxonomy, TaxNum) %>%
    distinct() %>%
    mutate(nodeleaf = gsub(".*\\|", "", Taxonomy),
           taxleaf = gsub(".*\\|", "", TaxNum)) %>%
    filter(nodeleaf %in% brb.enriched$term)
  
  # Retrieve phylogeny from NCBI
  taxids.leaf <- as.numeric(str_remove(alltax, ".*\\|"))
  taxize_allspec <- classification(taxids.leaf, db = "ncbi")
  ncbitree <- class2tree(taxize_allspec, check = T)
  
  # Extract ggplot-friendly tree
  getPhyloSegments <- function(phylotree, taxids){
    taxidkey <- as.data.frame(cbind(tname = phylotree$tip.label,
                                    taxid = as.character(taxids)))
    
    # Generate xy coords for edges and nodes
    tmp1 <- as(phylotree, "phylo4")
    tmp <- phylobase::phyloXXYY(tmp1)
    
    # Handle node labelling. To get the labels into the correct order, look at the edges object in the phy object contained in the phylo4 object. Pull the descendents column and it will have the order of the tips. Do not try to use the edge order or tip labels from the top level of the phylo4 object.
    nodepts.unlab <- as.data.frame(cbind(xx = tmp$xx, yy = tmp$yy)) %>%
      mutate(xx = as.numeric(xx),
             yy = as.numeric(yy))
    nodepts.unlab$tname <- tmp$phy@label[tmp$phy@edge[,2]]
    
    nodepts <- nodepts.unlab %>%
      left_join(taxidkey)
    
    # Make segments into a long df, instead of separated by horizontal and vertical segments.
    segs1 <- as.data.frame(tmp$segs)[,1:4]
    segs2 <- as.data.frame(tmp$segs)[,5:8]
    colnames(segs2) <- gsub("h", "v", colnames(segs2))
    segs <- bind_rows(segs1,segs2)
    
    phylcoords <- list(segs, nodepts)
    names(phylcoords) <- c("Segments", "Nodes")
    return(phylcoords)
  }
  
  # Matchresulting data to enrichment info
  phylo.coords <- getPhyloSegments(ncbitree$phylo, taxids.leaf)
  nodes.forjoin <- phylo.coords$Nodes %>%
    mutate(Lachno = ifelse(taxid %in% brb.enriched.taxids$taxleaf, "Lachno", "Not Lachno")) %>%
    filter(Lachno == "Lachno")
  
  outs <- list(phylo.coords$Segments, nodes.forjoin)
  names(outs) <- c("Segments", "Nodes")
  
  return(outs)
}
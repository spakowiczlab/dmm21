barDatMimic <- function(seqtab, tax, key){
  
  taxa.spread <- tax %>%
    as.data.frame() %>%
    rownames_to_column(var = "ASV") %>%
    mutate(Phylum=if_else(is.na(Phylum),paste0("p_unclassified_",Kingdom),Phylum),
           Class=if_else(is.na(Class),paste0("c_unclassified_",Phylum),Class),
           Order=if_else(is.na(Order),paste0("o_unclassified_",Class),Order),
           Family=if_else(is.na(Family),paste0("f_unclassified_",Order),Family),
           Genus=if_else(is.na(Genus),paste0("g_unclassified_",Family),Genus),
           Species=if_else(is.na(Species),paste0("s_unclassified_",Genus),Species))
  
  relabun <- seqtab %>%
    as.data.frame() %>%
    rownames_to_column(var = "sampleID") %>%
    pivot_longer(-sampleID, names_to = "ASV", values_to = "counts") %>%
    mutate(totcount = sum(counts), .by = sampleID) %>%
    mutate(rel_abun = counts/totcount) %>%
    left_join(taxa.spread) %>%
    group_by(sampleID, Genus) %>%
    summarise(genus_abundance = sum(rel_abun)) 
  
  key.10 <- key %>%
    filter(experiment == "mimic 10") %>%
    filter(timepoint == "baseline" | timepoint == "necropsy") %>%
    mutate(gavage.simple = ifelse(grepl("Pre-BRB",gavage),"rB","tB"),
           sampleID = as.character(sampleID)) %>% 
    select(sampleID,timepoint,gavage.simple, treatment)
  
  relabun.roseburia <- key.10 %>%
    left_join(relabun) %>%
    filter(Genus == "Roseburia") 
  
  return(relabun.roseburia)
}

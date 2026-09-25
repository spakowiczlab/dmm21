#' Taxa that differ by diet in the rat feeding study.
#'
#' Counts are summed at phylum through genus and compared with a DESeq2
#' model of \code{~ group}.
#'
#' @param seq Sample-by-ASV count matrix.
#' @param tax ASV taxonomy with ranks from kingdom through genus.
#' @param groups Sample metadata with \code{sample} and \code{group}.
#' @return DESeq2 results for every rank, with a \code{TaxLev} column.
difMicsRB <- function(seq,tax, groups){
  
  tax.tmp <- tax %>%
    as.data.frame() %>%
    rownames_to_column(var="ASV") %>%
    mutate(Phylum=if_else(is.na(Phylum),paste0("p_unclassified_",Kingdom),Phylum),
           Class=if_else(is.na(Class),paste0("c_unclassified_",Phylum),Class),
           Order=if_else(is.na(Order),paste0("o_unclassified_",Class),Order),
           Family=if_else(is.na(Family),paste0("f_unclassified_",Order),Family),
           Genus=if_else(is.na(Genus),paste0("g_unclassified_",Family),Genus))
  
  seq.tmp <- seq %>%
    as.data.frame() %>%
    rownames_to_column(var = "sample") %>%
    pivot_longer(-sample, names_to = "ASV", values_to = "counts") %>%
    left_join(tax.tmp)
  
  makeLevTabs <- function(lev){
    tmp <- seq.tmp %>%
      rename("Tax" := !!lev) %>%
      group_by(sample, Tax) %>%
      summarise(counts = sum(counts)) %>%
      ungroup() %>%
      pivot_wider(names_from = sample, values_from = counts) %>%
      column_to_rownames(var = "Tax") %>%
      dplyr::select(groups$sample)
  }
  
  tlevs <- c("Phylum", "Class", "Order", "Family", "Genus")
  seq.list <- lapply(tlevs, makeLevTabs)
  names(seq.list) <- tlevs
  
  DESeqLev <- function(tmat){
    dds <- DESeq2::DESeqDataSetFromMatrix(countData = tmat, colData = groups, design = ~group)
    dds <- DESeq2::DESeq(dds)
    dds.res <- DESeq2::results(dds) %>%
      as.data.frame() %>%
      arrange(padj)
  }
  
  dds.res.all <- lapply(seq.list, DESeqLev)
  dds.res.df <- lapply(names(dds.res.all), function(x) dds.res.all[[x]] %>%
                         rownames_to_column(var = "Taxa") %>%
                          mutate(TaxLev = x)) %>%
    bind_rows()
  
  return(dds.res.df)
  
}
#' PCA of a published immunotherapy-response signature.
#'
#' BE WELL samples are recoded to pre/post placebo and pre/post black
#' raspberry. Published responder and non-responder labels are left as they are.
#'
#' @param x Sample-by-taxon table with a \code{sample} column.
#' @param meta Sample metadata with \code{sample}, \code{dataset}, and \code{response}.
#' @return A list of the PCA coordinates joined to \code{meta}, and the
#'   proportion of variance explained by each component.
respondersigPCA <- function(x, meta){
  meta <- meta %>%
    mutate(hull = ifelse(dataset == "BEWELL", NA, response),
           response = case_when(response == "rP" ~ "Pre-Placebo",
                                response == "tP" ~ "Post-Placebo",
                                response == "rB" ~ "Pre-BRB",
                                response == "tB" ~ "Post-BRB",
                                .default = response))
  
  meta$response <- factor(meta$response, levels = c("Responder", "Non_Responder", "Pre-Placebo", "Post-Placebo", "Pre-BRB", "Post-BRB"))
  #resp <- as.factor(meta[, "response"])
  # batch <- as.factor(meta[, "dataset"])
  # 
  # hull <- as.factor(meta[, "hull_group"])

  x <- x %>%
    #arrange(sample) %>%
    column_to_rownames("sample")
  
  pca<- pca(x, ncomp = 3, scale = TRUE)
  
  plot_input <- pca$variates$X %>%
    cbind(meta)
  
  expl_var <- pca$prop_expl_var$X
  
  input <- list(plot_input, expl_var)
  
  return(input)
}


respondersigPrepScatter <- function(x, meta){
  meta <- meta %>%
    mutate(hull_group = ifelse(response %in% c("rP", "tP", "rB"), "Non-BRB",
                               ifelse(response == "tB", "BRB",
                                      response)),
           response = case_when(response == "rP" ~ "Pre-Placebo",
                                response == "tP" ~ "Post-Placebo",
                                response == "rB" ~ "Pre-BRB",
                                response == "tB" ~ "Post-BRB",
                                .default = response)) 
  
  resp <- factor(meta$response, levels = c("Responder", "Non_Responder", "Pre-Placebo", "Post-Placebo", "Pre-BRB", "Post-BRB"))
  #resp <- as.factor(meta[, "response"])
  batch <- as.factor(meta[, "dataset"])
  
  hull <- as.factor(meta[, "hull_group"])
  
  x <- x %>%
    #arrange(sample) %>%
    column_to_rownames("sample")
  
  pca<- pca(x, ncomp = 3, scale = TRUE)
  
  plot_input <- list(pca, batch, resp, hull)
  
  return(plot_input)
}
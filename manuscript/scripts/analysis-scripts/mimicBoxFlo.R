mimicBoxFlo <- function(flopath){
  x <- read_csv(flopath) %>%
    rename("mouse.cage" = "...1") %>%
    filter(grepl("^M", mouse.cage)) %>%
    mutate(BRB = fct_relevel(BRB, "pre")) %>%
    rename("Gavage" = "BRB") %>%
    mutate(Gavage = if_else(grepl("pre", Gavage),
                            true = "Pre-BRB",
                            false = "Post-BRB")) %>%
    gather(-mouse.cage, -Gavage, -Treatment, key = "Marker", value = "Percent") %>%
    mutate(Gavage = fct_relevel(Gavage, c("Pre-BRB"))) %>%
    mutate(Treatment = fct_relevel(Treatment, c("IgG")))
  
  return(x)
}

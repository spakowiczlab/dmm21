quadLongMod <- function(allexp){

  # Ok, process main chunks of data
  processed.data <- allexp %>%
    mutate(gavage = if_else(grepl("v1|v3", microbiome.sample),
                            true = "Pre-BRB",
                            false = if_else(grepl("v2|v4", microbiome.sample),
                                            true = "Post-BRB",
                                            false = "other"))) %>%
    mutate(gavage = fct_relevel(gavage, "Pre-BRB")) %>%
    mutate(treatment = fct_relevel(treatment, "IgG")) %>%
    mutate(days2 = days.from.injection^2)
  
  fitness.data <- processed.data %>%
    filter(experiment %in% c("mimic2", "mimic3", "mimic8")) %>%
    mutate(SPPB = ifelse(experiment == "mimic2", "Low", "High"),
           treatment = ifelse(grepl("PD1", treatment), "Anti-PD1", "IgG")) %>%
    mutate(SPPB = fct_relevel(SPPB, "Low"),
           treatment = fct_relevel(treatment, "IgG")) %>%
    mutate(days2 = days.from.injection^2) %>%
    mutate(Response = if_else(grepl("Low", SPPB),
                              true = "Non-responder",
                              false = "Responder"),
           Response = if_else(grepl("Saline", microbiome.sample),
                              true = "Saline",
                              false = Response))
  
  # Now make list of data sets for each test
  model.inputs <- list(
    "HONC60-55" = processed.data %>%
      filter(grepl("C60-55", microbiome.sample)),
    "HONC60-84" = processed.data %>%
      filter(grepl("mimic4", experiment)),
    "HONC60-102" = processed.data %>%
      filter(grepl("mimic5", experiment)),
    "HONC60-62" = processed.data %>%
      filter(grepl("mimic9", experiment)) %>%
      mutate( gavage = if_else(grepl("v4", microbiome.sample),
                               true = "Post-Placebo",
                               false = "Post-BRB")) %>%
      mutate(gavage = fct_relevel(gavage, "Post-Placebo")),
    "HONC60-68" = processed.data %>%
      filter(grepl("mimic10", experiment)),
    "HONC60-79" = processed.data %>%
      filter(grepl("C60-79", microbiome.sample)) %>%
      mutate( gavage = if_else(grepl("v2", microbiome.sample),
                               true = "Post-Placebo",
                               false = "Post-BRB")) %>%
      mutate(gavage = fct_relevel(gavage, "Post-Placebo")),
    "HONC60-85" = processed.data %>%
      filter(grepl("C60-85", microbiome.sample)), 
    "HONC60-84mm13" = processed.data %>%
      filter(grepl("C60-84", microbiome.sample)),
    "DL017(Responder)" = fitness.data %>%
      filter(Response != "Non-responder") %>%
      mutate(gavage = fct_relevel(Response, "Saline")), # Call the response column gavage just to make the model function smoother
    "DL081(Non-responder)" = fitness.data %>%
      filter(Response != "Responder") %>%
      mutate(gavage = fct_relevel(Response, "Saline"))
    
  )
  
  # Need to set up a DF containing the info associate with each model, name in a reasonable way so it can join easily
  
  samp.inf <- as.data.frame(
    cbind(
      experiment = c("mimic10","mimic1,6,7","mimic5","mimic4","mimic9","mimic11","mimic12","mimic13","mimic2,3,8","mimic2,3,8"),
      trial = c("BEWELL","BEWELL","BEWELL","BEWELL","BEWELL","BEWELL","BEWELL","BEWELL","Fitness","Fitness"),
      `sample ID` = c("HONC60-68", "HONC60-55","HONC60-102","HONC60-84","HONC60-62","HONC60-79","HONC60-85","HONC60-84mm13","DL017(Responder)","DL081(Non-responder)"),
      hypothesis = c("Roseburia","Random Sample","Random Sample","Random Sample","Akkermansia","Lachnospira","Blautia", "Blautia", "Response","Response"),
      `Combined ID` = c("Roseburia (68)","Random (55)","Random (102)","Random (84)","Akkermansia (62)","Lachnospira (79)","Blautia (85)","Blautia (84)","Responder (DL017)","Non-responder (DL081)")
    )
  )
  
  # I can make this work better by making it start from data as models are all consistent
  processModel <- function(mdata, mname) {
    
    model <- lmer(tumor.volume ~ days.from.injection + days2 * treatment * gavage + (1|unique.mouse.id),
                  data = mdata)
    model %>%
      tidy() %>%
      mutate(abs.estimate = abs(estimate),
             plus.minus = ifelse(estimate > 0, "p", "n"),
             log.estimate = log10(abs.estimate)) %>%
      mutate(log.estimate = ifelse(plus.minus == "n", 
                                   -1*log.estimate, 
                                   log.estimate),
             log.std.error = log10(std.error),
             log.std.error = abs(log.std.error)) %>%
      mutate(sig.flag = ifelse(p.value < 0.05, "S", "NS"),
             conf.low = estimate - std.error,
             conf.high = estimate + std.error,
             log.conf.low = log.estimate - log.std.error,
             log.conf.high = log.estimate + log.std.error,
             ci95.low = estimate - (1.96 * std.error),
             ci95.high = estimate + (1.96 * std.error)) %>% # This seems like a weird scalar to me?
      filter(is.na(group)) %>%
      filter(term != "(Intercept)") %>%
      mutate(`sample ID` = mname)
  }
  
  mres.list <- lapply(names(model.inputs), function(x) try(processModel(model.inputs[[x]], x))) %>%
    bind_rows() %>%
    left_join(samp.inf)
  
  mres.form <- mres.list %>%
    filter(!grepl("mimic4|mimic9", experiment)) %>%
    filter(grepl("days2:", term)) %>%
    mutate(term.adj = gsub("treatmentPD1", "treatmentAnti-PD1", term)) %>%
    mutate(term.adj = str_replace(term.adj, "treatmentAnti-PD1", "Anti-PD1")) %>%
    mutate(term.adj = str_replace(term.adj, "gavagePost-BRB", "Gavage")) %>%
    mutate(term.adj = str_replace(term.adj, "gavageResponder", "Gavage")) %>%
    mutate(term.adj = str_replace(term.adj, "gavageNon-responder", "Gavage")) %>%
    mutate(term.adj = str_remove(term.adj, "days2:")) %>%
    mutate(term.adj = fct_relevel(term.adj,"Gavage","Anti-PD1","Anti-PD1:Gavage")) %>%
    mutate(`Combined ID` = fct_relevel(`Combined ID`,
                                       "Non-responder (DL081)",
                                       "Responder (DL017)",
                                       "Random (102)", 
                                       "Random (55)", 
                                       "Blautia (84)",
                                       "Blautia (85)",
                                       "Roseburia (68)",
                                       "Lachnospira (79)"))
  
  return(mres.form)
}

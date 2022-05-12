# load objects
rm(list= ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))])
load(file = file.path(path_panel, 'filtered_panels.RData'))

load(file = file.path(path_models, 'panel_looper.RDs'))
D <- length(panels)
d = 1

# cs loop
foreach(d = 1:D) %do% {
  # which panel are we working on
  pane <- panels[d]
  
  # pre-processing the filtered panel
  panel_cs = get(pane) %>% 
    mutate(loginfl_loans = log(loans+1), 
           treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                                "0", substr(year_scanned, 9, nchar(year_scanned)))), 
           treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001))
  
  # estimate atts
  atts <- att_gt(yname = 'loginfl_loans', # LHS variable
                 tname = 't', # panel time variable
                 idname = 'bib_doc_id', # firms' panel id variable
                 gname = 'treatment_period', 
                 data = panel_cs, # data
                 est_method = "dr",
                 control_group = "notyettreated",
                 bstrap = TRUE, # if TRUE compute bootstrapped SE
                 biters = 10, # number of bootstrap iterations
                 print_details = FALSE, # if TRUE, print detailed results
                 clustervars = 'bib_doc_id', # cluster level
                 panel = TRUE)
  
  # agregate atts
  mod_cs <- aggte(atts, type = "group", balance_e = TRUE, na.rm = TRUE)

  # saving files
  fname_cs <- paste(substr(pane, 10, nchar(pane)), "cs.RDs", sep = "_")
  save(file = file.path(path_models, fname_cs), list = "mod_cs")
}

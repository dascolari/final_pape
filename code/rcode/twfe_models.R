# load objects
rm(list= ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))])
load(file = file.path(path_panel, 'filtered_panels.RData'))

load(file = file.path(path_models, 'panel_looper.RDs'))
D <- length(panels)

# twfe loop
foreach(d = 1:D) %do% {
  # which panel are we working on
  pane <- panels[d]
  
  # pre-processing the filtered panel
  panel_twfe = get(pane) %>% 
    mutate(loginfl_loans = log(loans+1))
  
  # specify twfe model
  mod_twfe <-  feols(fml = loginfl_loans ~ scanned + t | bib_doc_id, 
                     data = panel_twfe, 
                     vcov = ~ t + bib_doc_id)
  
  
  fname_twfe <- paste(substr(pane, 10, nchar(pane)), "twfe.RDs", sep = "_")
  save(file = file.path(path_models, fname_twfe), list = "mod_twfe")
}
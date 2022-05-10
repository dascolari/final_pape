rm(list= ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))])
load(file = file.path(path_panel, 'rpanels.RData'))


base_twfe <- base %>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1))

SA_mod <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
                data = base_twfe,
                subset = ~ t < 9)

summary(SA_mod)
SA_mod["coefficients"]
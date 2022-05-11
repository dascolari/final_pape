# load objects
rm(list= ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))])
load(file = file.path(path_panel, 'rpanels.RData'))

# prepare data for SA
base_twfe <- base %>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1))

# preliminary SA model
SA_mod <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
                data = base_twfe,
                subset = ~ t < 9)

summary(SA_mod)
SA_mod["coefficients"]

# filtering for faculty
faculty_twfe = faculty %>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1)) %>% filter(type == 'faculty')

SA_mod_faculty <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
                        data = faculty_twfe,
                        subset = ~ t < 9)

summary(SA_mod)
SA_mod["coefficients"]

# filtering for inbuilding
inbuilding_twfe = inbuilding %>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1)) %>% filter(type == 'inbuilding')

SA_mod_building <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
                         data = inbuilding_twfe,
                         subset = ~ t < 9)

summary(SA_mod)
SA_mod["coefficients"]

#filtering for doctors
doc_twfe = students %>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1)) %>% filter(type == 'doctor')

SA_mod_doc <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
                    data = doc_twfe,
                    subset = ~ t < 9)

#filtering for masters
mas_twfe = students %>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1)) %>% filter(type == 'master')

SA_mod_mas <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
                    data = mas_twfe,
                    subset = ~ t < 9)

#filtering for undergrad
under_twfe = students %>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1)) %>% filter(type == 'undergrad')

SA_mod_mas <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
                    data = under_twfe,
                    subset = ~ t < 9)

# #filtering for nonstudents
# non_twfe = students %>% 
#   mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
#                                               "0", substr(year_scanned, 9, nchar(year_scanned)))), 
#          treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
#   mutate(loginfl_loans = log(loans+1)) %>% filter(type == 'non_students')
# 
# SA_mod_mas <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
#                     data = non_twfe,
#                     subset = ~ t < 9)


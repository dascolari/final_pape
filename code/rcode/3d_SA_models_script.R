# load objects
rm(list= ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))])
load(file = file.path(path_panel, 'rpanels.RData'))

# prepare data for SA
base_SA <- base %>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1))

# preliminary SA model
mod_SA <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
                data = base_SA,
                subset = ~ t < 9)

summary(mod_SA)
mod_SA["coefficients"]

# filtering for faculty
faculty_SA = faculty %>%
  filter(type == 'faculty')

faculty_mod_SA <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
                        data = faculty_SA,
                        subset = ~ t < 9)

summary(SA_mod)
SA_mod["coefficients"]

# filtering for inbuilding
inbuilding_SA = inbuilding %>% 
  filter(type == 'inbuilding')

inbuilding_mod_SA <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
                         data = inbuilding_SA,
                         subset = ~ t < 9)

summary(SA_mod)
SA_mod["coefficients"]

#filtering for doctors
doc_SA = students %>%
  filter(type == 'doctor')

doc_mod_SA <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
                    data = doc_SA,
                    subset = ~ t < 9)

#filtering for masters
mas_SA = students %>% 
  filter(type == 'master')

mas_mod_SA <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
                    data = mas_SA,
                    subset = ~ t < 9)

#filtering for undergrad
under_SA = students %>% 
  filter(type == 'undergrad')

under_mod_SA <- feols(fml = loginfl_loans ~ sunab(treatment_period, t) + scanned, 
                    data = under_SA,
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


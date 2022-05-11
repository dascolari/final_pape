# load objects
rm(list= ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))])
load(file = file.path(path_panel, 'rpanels.RData'))

#base twfe model
base_twfe = base %>% 
  mutate(loginfl_loans = log(loans+1))

mod_twfe <-  feols(fml = loginfl_loans ~ scanned | t, 
                     data = base_twfe)

## filtering for faculty

faculty_twfe = faculty %>%
  filter(type == 'faculty') %>% 
  mutate(loginfl_loans = log(loans+1))

faculty_mod_twfe <-  feols(fml = loginfl_loans ~ scanned | t, 
                   data = faculty_twfe)


#filtering for inbuilding
inbuilding_twfe = inbuilding %>%
  filter(type == 'inbuilding')%>% 
  mutate(loginfl_loans = log(loans+1))

inbuilding_mod_twfe <-  feols(fml = loginfl_loans ~ scanned | t,
                   data = inbuilding_twfe)

summary(SA_mod)
SA_mod["coefficients"]

#filtering for doctors
doc_twfe = students %>%
  filter(type == 'doctor') %>% 
  mutate(loginfl_loans = log(loans+1))

doc_mod_twfe <-  feols(fml = loginfl_loans ~ scanned | t, 
                              data = doc_twfe)

#filtering for masters
mas_twfe = students %>% 
  filter(type == 'master') %>% 
  mutate(loginfl_loans = log(loans+1))

mas_mod_twfe <-  feols(fml = loginfl_loans ~ scanned | t, 
                       data = mas_twfe)

#filtering for undergrad
under_twfe = students %>% 
  filter(type == 'undergrad') %>% 
  mutate(loginfl_loans = log(loans+1))

under_mod_twfe <-  feols(fml = loginfl_loans ~ scanned | t, 
                       data = under_twfe)


#saving files
save(file = file.path(path_models, 'twfe_faculty.RDs'), list = "faculty_mod_twfe")
save(file = file.path(path_models, 'twfe_inbuilding.RDs'), list = "inbuilding_mod_twfe")
save(file = file.path(path_models, 'twfe_under.RDs'), list = "under_mod_twfe")
save(file = file.path(path_models, 'twfe_mas.RDs'), list = "mas_mod_twfe")
save(file = file.path(path_models, 'twfe_doc.RDs'), list = "doc_mod_twfe")




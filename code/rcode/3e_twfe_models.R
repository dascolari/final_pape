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
  filter(type == 'faculty')

faculty_mod_twfe <-  feols(fml = loginfl_loans ~ scanned | t, 
                   data = faculty_twfe)


# filtering for inbuilding
# inbuilding_twfe = inbuilding %>% 
#   filter(type == 'inbuilding')
# 
# inbuilding_mod_twfe <-  feols(fml = loginfl_loans ~ scanned | t, 
#                    data = inbuilding_twfe)

summary(SA_mod)
SA_mod["coefficients"]

#filtering for doctors
doc_twfe = students %>%
  filter(type == 'doctor')

doc_mod_twfe <-  feols(fml = loginfl_loans ~ scanned | t, 
                              data = doc_twfe)

#filtering for masters
mas_twfe = students %>% 
  filter(type == 'master')

mas_mod_twfe <-  feols(fml = loginfl_loans ~ scanned | t, 
                       data = mas_twfe)

#filtering for undergrad
under_twfe = students %>% 
  filter(type == 'undergrad')

under_mod_twfe <-  feols(fml = loginfl_loans ~ scanned | t, 
                       data = under_twfe)
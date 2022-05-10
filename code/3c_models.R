# specifcy models with new school estimators
# rm and then load to control exactly what is in environment
rm(list= ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))])
load(file = file.path(path_panel, 'rpanels.RData'))

# bacon for base
cohorts <- base %>%
    group_by(year_scanned, scanned, t) %>%
    summarise(loans = sum(loans), .groups = 'drop')

# formula for index outcome
bacon_formula <- as.formula(paste("loans", "scanned", sep = " ~ "))

# specify bacon decomposition
# wrangle full df of 2x2s into summary table by type
bacon_decomp = bacon(bacon_formula, 
                     data = cohorts, 
                     id_var = "year_scanned", 
                     time_var = "t")%>%
  group_by(type) %>% 
  summarise(avg_est = weighted.mean(estimate, weight), 
            weight = sum(weight)) %>% as.data.frame()
save(file = file.path(path_models, 'bacon_decomp.RDs'), list = "bacon_decomp")



base_cs <- base %>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                             "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1))

# carlos santanna for base
atts <- att_gt(yname = 'loginfl_loans', # LHS variable
               tname = 't', # panel time variable
               idname = 'bib_doc_id', # firms' panel id variable
               gname = 'treatment_period', 
               data = base_cs, # data
               xformla = ~ location,
               est_method = "dr",
               control_group = "notyettreated",
               bstrap = TRUE, # if TRUE compute bootstrapped SE
               biters = 10, # number of bootstrap iterations
               print_details = FALSE, # if TRUE, print detailed results
               clustervars = 'bib_doc_id', # cluster level
               panel = TRUE)

cs_model <- aggte(atts, type = "group", balance_e = TRUE, na.rm = TRUE)
save(file = file.path(path_models, 'cs_model.RDs'), list = "cs_model")

twfe_formula <-  as.formula("loginfl_loans ~ scanned + location*t")

twfe_mod <- feols(fml = twfe_formula, 
                  data = base_twfe, 
                  se = "cluster", 
                  fixef = "bib_doc_id")

# sa_checkout = feols(loginfl_loans ~ , data = base_twfe, subset = ~ year < 

base_twfe <- base %>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1))

SA_mod <- feols(fml = loginfl_loans ~ sunab(treatment_period, year_loaned) + scanned, 
                data = base_twfe,
                subset = ~ year_loaned < 2011)

summary(SA_mod)
SA_mod["coefficients"]

# # all this is the bud of a loop that I'm working on to do all of our panels at once
# # but it isn't ready yet, so i comment it out
# panel_names <- ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))]
# D <- length(panel_names)
# 
# foreach(d = 1:D) %do% {
#   panel <- get(panel_names[d])
#   
#   cohorts <- panel %>% 
#     group_by(year_scanned, scanned, t) %>% 
#     summarise(loans = sum(loans), .groups = 'drop')
#   }
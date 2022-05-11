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



# specifcy models with new school estimators
# rm and then load to control exactly what is in environment
rm(list= ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))])
load(file = file.path(path_panel, 'rpanels.RData'))


# data
base <- read_dta("data/panel_data/base.dta")
faculty<- read_dta("data/panel_data/faculty.dta")
students<- read_dta("data/panel_data/students.dta")
inbuilding<- read_dta("data/panel_data/inbuilding.dta")

# cleaning data frame
df_base<- base %>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1))


df_faculty <- faculty %>% 
  filter(type == "faculty")%>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1))

df_undergrad <- students %>% 
  filter(type == "undergrad")%>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1))

df_master <- students %>% 
  filter(type == "master")%>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1))

df_doctor <- students %>% 
  filter(type == "doctor")%>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1))

df_inbuilding <- inbuilding %>% 
  filter(type == "inbuilding")%>% 
  mutate(treatment_period = as.numeric(ifelse(year_scanned == "never_treated", 
                                              "0", substr(year_scanned, 9, nchar(year_scanned)))), 
         treatment_period = ifelse(treatment_period == 0, 0, treatment_period - 2001)) %>% 
  mutate(loginfl_loans = log(loans+1))



# models
atts <- att_gt(yname = 'loginfl_loans', # LHS variable
               tname = 't', # panel time variable
               idname = 'bib_doc_id', # firms' panel id variable
               gname = 'treatment_period', 
               data = df_base, # data
               xformla = ~ location,
               est_method = "dr",
               control_group = "notyettreated",
               bstrap = TRUE, # if TRUE compute bootstrapped SE
               biters = 10, # number of bootstrap iterations
               print_details = FALSE, # if TRUE, print detailed results
               clustervars = 'bib_doc_id', # cluster level
               panel = TRUE)


atts_faculty <- att_gt(yname = 'loginfl_loans', # LHS variable
                       tname = 't', # panel time variable
                       idname = 'bib_doc_id', # firms' panel id variable
                       gname = 'treatment_period', 
                       data = df_faculty, # data
                       xformla = ~ location,
                       est_method = "dr",
                       control_group = "notyettreated",
                       bstrap = TRUE, # if TRUE compute bootstrapped SE
                       biters = 10, # number of bootstrap iterations
                       print_details = FALSE, # if TRUE, print detailed results
                       clustervars = 'bib_doc_id', # cluster level
                       panel = TRUE)

atts_undergrad <- att_gt(yname = 'loginfl_loans', # LHS variable
                         tname = 't', # panel time variable
                         idname = 'bib_doc_id', # firms' panel id variable
                         gname = 'treatment_period', 
                         data = df_undergrad, # data
                         xformla = ~ location,
                         est_method = "dr",
                         control_group = "notyettreated",
                         bstrap = TRUE, # if TRUE compute bootstrapped SE
                         biters = 10, # number of bootstrap iterations
                         print_details = FALSE, # if TRUE, print detailed results
                         clustervars = 'bib_doc_id', # cluster level
                         panel = TRUE)

atts_master <- att_gt(yname = 'loginfl_loans', # LHS variable
                      tname = 't', # panel time variable
                      idname = 'bib_doc_id', # firms' panel id variable
                      gname = 'treatment_period', 
                      data = df_master, # data
                      xformla = ~ location,
                      est_method = "dr",
                      control_group = "notyettreated",
                      bstrap = TRUE, # if TRUE compute bootstrapped SE
                      biters = 10, # number of bootstrap iterations
                      print_details = FALSE, # if TRUE, print detailed results
                      clustervars = 'bib_doc_id', # cluster level
                      panel = TRUE)

atts_doctor <- att_gt(yname = 'loginfl_loans', # LHS variable
                      tname = 't', # panel time variable
                      idname = 'bib_doc_id', # firms' panel id variable
                      gname = 'treatment_period', 
                      data = df_doctor, # data
                      xformla = ~ location,
                      est_method = "dr",
                      control_group = "notyettreated",
                      bstrap = TRUE, # if TRUE compute bootstrapped SE
                      biters = 10, # number of bootstrap iterations
                      print_details = FALSE, # if TRUE, print detailed results
                      clustervars = 'bib_doc_id', # cluster level
                      panel = TRUE)

atts_inbuilding <- att_gt(yname = 'loginfl_loans', # LHS variable
                          tname = 't', # panel time variable
                          idname = 'bib_doc_id', # firms' panel id variable
                          gname = 'treatment_period', 
                          data = df_inbuilding, # data
                          xformla = ~ location,
                          est_method = "dr",
                          control_group = "notyettreated",
                          bstrap = TRUE, # if TRUE compute bootstrapped SE
                          biters = 10, # number of bootstrap iterations
                          print_details = FALSE, # if TRUE, print detailed results
                          clustervars = 'bib_doc_id', # cluster level
                          panel = TRUE)




# saving files
cs_model <- aggte(atts, type = "group", balance_e = TRUE, na.rm = TRUE)
save(file = file.path(path_models, 'cs_model.RDs'), list = "cs_model")

cs_faculty <- aggte(atts_faculty, type = "group", balance_e = TRUE, na.rm = TRUE)
save(file = file.path(path_models, 'cs_faculty.RDs'), list = "cs_faculty")

cs_undergrad <- aggte(atts_undergrad, type = "group", balance_e = TRUE, na.rm = TRUE)
save(file = file.path(path_models, 'cs_undergrad.RDs'), list = "cs_undergrad")

cs_master <- aggte(atts_master, type = "group", balance_e = TRUE, na.rm = TRUE)
save(file = file.path(path_models, 'cs_master.RDs'), list = "cs_master")

cs_doctor <- aggte(atts_doctor, type = "group", balance_e = TRUE, na.rm = TRUE)
save(file = file.path(path_models, 'cs_doctor.RDs'), list = "cs_doctor")

cs_inbuilding <- aggte(atts_inbuilding, type = "group", balance_e = TRUE, na.rm = TRUE)
save(file = file.path(path_models, 'cs_inbuilding.RDs'), list = "cs_inbuilding")


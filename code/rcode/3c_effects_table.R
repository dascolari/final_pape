rm(list= ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))])
load(file.path(path_models, 'bacon_decomp.RDs'))
load(file.path(path_models, 'cs_model.RDs'))
load(file.path(path_models, 'twfe_model.RDs'))
load(file.path(path_models, 'cs_faculty.RDs'))
load(file.path(path_models, 'cs_undergrad.RDs'))
load(file.path(path_models, 'cs_master.RDs'))
load(file.path(path_models, 'cs_doctor.RDs'))
load(file.path(path_models, 'cs_inbuilding.RDs'))

# access estimates, se, tvals, and pvals from each model

estimates <- c("Estimated ATT", twfe_mod[["coefficients"]][["scanned"]], cs_model[["overall.att"]])
se <- c("", twfe_mod[["se"]][["scanned"]], cs_model[["overall.se"]])

est_cs_faculty <- c("Faculty ATT", "", cs_faculty[["overall.att"]])
se_cs_faculty <- c("", "", cs_faculty[["overall.se"]])

est_cs_undergrad <- c("Undergrad ATT", "", cs_undergrad[["overall.att"]])
se_cs_undergrad <- c("", "", cs_undergrad[["overall.se"]])

est_cs_master <- c("Master ATT", "", cs_master[["overall.att"]])
se_cs_master <- c("", "", cs_master[["overall.se"]])

est_cs_doctor <- c("Doctor ATT", "", cs_doctor[["overall.att"]])
se_cs_doctor <- c("", "", cs_doctor[["overall.se"]])

est_cs_inbuilding <- c("Inbuilding ATT", "", cs_inbuilding[["overall.att"]])
se_cs_inbuilding <- c("", "", cs_inbuilding[["overall.se"]])




effects <- rbind(estimates, se,
              est_cs_faculty, se_cs_faculty,
              est_cs_undergrad, se_cs_undergrad,
              est_cs_master, se_cs_master,
              est_cs_doctor, se_cs_doctor,
              est_cs_inbuilding, se_cs_inbuilding) %>% as.data.frame()
# this stuff is for p vals, but they thicccccc so we don't even need them 
# gimme_tha_p <- as.data.frame(twfe_model[["coeftable"]])
# p <- c(yval, gimme_tha_p$`Pr(>|t|)`[1], "")


# doctor up the effecs a lil bit
colnames(effects) <- c("V1", "TWFE", "CS")
rownames(effects) <- NULL
effects$TWFE <- round(as.numeric(effects$TWFE), 3)
effects$CS <- round(as.numeric(effects$CS), 3)
# effects$TWFE <- as.character(effects$TWFE)
# effects$CS <- as.character(effects$CS)

effects <- effects %>%
  mutate(significance = ifelse(row_number()==2, "",
                               case_when(abs(TWFE)/lead(TWFE) - abs(CS)/lead(CS) > 0 ~ "Less",
                                         abs(TWFE)/lead(TWFE) - abs(CS)/lead(CS) <= 0 ~ "More")),
         sign_change = ifelse(row_number()%%2 == 0, "",
                              case_when(sign(TWFE) == sign(CS)~ "No",
                                        sign(TWFE) != sign(CS)~ "Yes"))) %>%
  mutate(TWFE = ifelse(row_number()%%2 == 0, paste0("(", TWFE, ")"), TWFE),
         CS = ifelse(row_number()%%2 == 0, paste0("(", CS, ")"), CS))

colnames(effects) <- c("Outcome", "TWFE", "Calloway Sant'Anna", "Significance", "Sign Change")

#making a table 
effects_table <- stargazer(effects, 
                           type = "latex", 
                           summary = FALSE, 
                           rownames = FALSE, 
                           title = "TWFE vs. CS Estimators",
                           table.placement = "h",
                           notes = "Standard errors in parenthesis")

write(effects_table, file = file.path(path_tables, 'effects_table.tex'))
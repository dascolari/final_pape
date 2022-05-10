rm(list= ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))])
load(file.path(path_models, 'bacon_decomp.RDs'))
load(file.path(path_models, 'cs_model.RDs'))
  
  # access estimates, se, tvals, and pvals from each model
  
estimates <- c("Estimated ATT", cs_model[["overall.att"]])
se <- c("", cs_model[["overall.se"]])

effects <- rbind(estimates, se) %>% as.data.frame()
  # this stuff is for p vals, but they thicccccc so we don't even need them 
  # gimme_tha_p <- as.data.frame(twfe_model[["coeftable"]])
  # p <- c(yval, gimme_tha_p$`Pr(>|t|)`[1], "")
  

# doctor up the effecs a lil bit
L <- length(effects$V1)
colnames(effects) <- c("ATT","CS")
rownames(effects) <- NULL
effects$CS <- round(as.numeric(effects$CS), 3)
# effects$TWFE <- as.character(effects$TWFE)
effects$CS <- as.character(effects$CS)

# effects <- effects %>% 
#   mutate(outcome = substr(outcome, 2, nchar(outcome))) %>% 
#   arrange(outcome) %>% 
#   mutate(significance = ifelse(outcome == "", "", 
#                                case_when(abs(TWFE)/lead(TWFE) - abs(CS)/lead(CS) > 0 ~ "Less", 
#                                          abs(TWFE)/lead(TWFE) - abs(CS)/lead(CS) <= 0 ~ "More")), 
#          sign_change = ifelse(outcome == "", "",
#                               case_when(sign(TWFE) == sign(CS)~ "No", 
#                                         sign(TWFE) != sign(CS)~ "Yes"))) %>% 
#   mutate(TWFE = ifelse(row_number()%%2 == 0, paste0("(", TWFE, ")"), TWFE), 
#          CS = ifelse(row_number()%%2 == 0, paste0("(", CS, ")"), CS))
# 
# colnames(effects) <- c("Outcome", "TWFE", "Calloway Sant'Anna", "Significance", "Sign Change")

#making a table 
effects_table <- stargazer(effects, 
                           type = "latex", 
                           summary = FALSE, 
                           rownames = FALSE, 
                           title = "TWFE vs. CS Estimators",
                           table.placement = "h",
                           notes = "Standard errors in parenthesis")

write(effects_table, file = file.path(path_tables, 'effects_table.tex'))


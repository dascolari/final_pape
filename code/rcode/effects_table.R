# load objects
rm(list= ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))])
load(file = file.path(path_panel, 'filtered_panels.RData'))

load(file = file.path(path_models, 'panel_looper.RDs'))
D <- length(panels)
d = 1

effects <- foreach(d = 1:D, .combine = 'rbind') %do% {
  # which panel are we working on
  pane <- panels[d]
  
  # loading models
  fname_twfe <- paste(substr(pane, 10, nchar(pane)), "twfe.RDs", sep = "_")
  fname_cs <- paste(substr(pane, 10, nchar(pane)), "cs.RDs", sep = "_")
  load(file.path(path_models, fname_twfe))
  load(file.path(path_models, fname_cs))
  
  # access estimates, se, tvals, and pvals from each model
  estimates <- c(substr(pane, 10, nchar(pane)), mod_twfe[["coefficients"]][["scanned"]], mod_cs[["overall.att"]])
  se <- c("", mod_twfe[["se"]][["scanned"]], mod_cs[["overall.se"]])

  rbind(estimates, se)
} %>% as.data.frame()

# doctor up the effecs a lil bit
colnames(effects) <- c("V1", "TWFE", "CS")
rownames(effects) <- NULL
effects$TWFE <- signif(as.numeric(effects$TWFE), 3)
effects$CS <- signif(as.numeric(effects$CS), 3)
# effects$TWFE <- as.character(effects$TWFE)
# effects$CS <- as.character(effects$CS)

effects <- effects %>%
  mutate(significance = ifelse(row_number()%%2 == 0, "",
                               case_when(abs(TWFE)/lead(TWFE) - abs(CS)/lead(CS) > 0 ~ "Less",
                                         abs(TWFE)/lead(TWFE) - abs(CS)/lead(CS) <= 0 ~ "More")),
         sign_change = ifelse(row_number()%%2 == 0, "",
                              case_when(sign(TWFE) == sign(CS)~ "No",
                                        sign(TWFE) != sign(CS)~ "Yes"))) %>%
  mutate(TWFE = ifelse(row_number()%%2 == 0, paste0("(", TWFE, ")"), TWFE),
         CS = ifelse(row_number()%%2 == 0, paste0("(", CS, ")"), CS), 
         V1 = ifelse(row_number()%%2 == 0, "", case_when(V1 == "base" ~ "All Bowrrowers", 
                        V1 == "fac" ~ "Faculty", 
                        V1 == "doc" ~ "Doctoral Students", 
                        V1 == "mas" ~ "Masters Students", 
                        V1 == "und" ~ "Undergraduate Students", 
                        V1 == "inb" ~ "In-Building")))

colnames(effects) <- c("Borrower Group", "TWFE", "Calloway Sant'Anna", "Significance", "Sign Change")

#making a table 
effects_table <- stargazer(effects, 
                           type = "latex", 
                           summary = FALSE, 
                           rownames = FALSE, 
                           title = "TWFE vs. Group CS Estimators",
                           table.placement = "h",
                           notes = "Standard errors in parenthesis")

write(effects_table, file = file.path(path_tables, 'effects_table.tex'))

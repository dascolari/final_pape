# specifcy models with new school estimators
# rm and then load to control exactly what is in environment
# rm(list = ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*|^filter*'))])
rm(list= ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))])
load(file = file.path(path_panel, 'filtered_panels.RData'))

# make a list of panels in envi for looping
panels <- ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))]
save(file = file.path(path_models, 'panel_looper.RDs'), list = "panels")
D <- length(panels)

# bacon loop
bacon_all <- foreach(d = 1:D, .combine = 'rbind') %do% {
  pane <- panels[d]
  pane
  substr(pane, 10, nchar(pane))

  cohorts <- get(pane) %>%
    group_by(year_scanned, scanned, t) %>%
    summarise(loans = sum(loans), .groups = 'drop')
  
  bacon_formula <- as.formula(paste("loans", "scanned", sep = " ~ "))
  
  # specify bacon decomposition
  # wrangle full df of 2x2s into summary table by type
  bacon_decomp <-  bacon(bacon_formula, 
                       data = cohorts, 
                       id_var = "year_scanned", 
                       time_var = "t")%>%
    group_by(type) %>% 
    summarise(avg_est = weighted.mean(estimate, weight), 
              weight = sum(weight)) %>% 
    mutate(filter = substr(pane, 10, nchar(pane))) %>% 
    as.data.frame()
  
  # output the data.frame we've built
  bacon_decomp
} %>% 
  mutate(avg_est = round(avg_est, 3), 
        weight = round(weight, 3), 
        filter = case_when(filter == "base" ~ "All Borrowers", 
                           filter == "fac" ~ "Faculty", 
                           filter == "doc" ~ "Doctoral Students", 
                           filter == "mas" ~ "Masters Students", 
                           filter == "und" ~ "Undergraduate Students", 
                           filter == "inb" ~ "In-Building")) %>% 
  dplyr::select(filter, type, avg_est, weight) %>% 
  arrange(filter)

filter_labels <- unique(bacon_all$filter)

bacon_table <- kable(bacon_all[2:4], 
                     format = "latex", 
                     caption = "Bacon Decompositison", 
                     col.names = c("2x2 Type", "Avg. Estimate", "Weight"),
                     booktabs = TRUE, 
) %>% 
  pack_rows(group_label = filter_labels[1], start_row = 1, end_row = 3) %>% 
  pack_rows(group_label = filter_labels[2], start_row = 3+1, end_row = 3*2) %>% 
  pack_rows(group_label = filter_labels[3], start_row = 3*2+1, end_row = 3*3) %>% 
  pack_rows(group_label = filter_labels[4], start_row = 3*3+1, end_row = 3*4) %>% 
  pack_rows(group_label = filter_labels[5], start_row = 3*4+1, end_row = 3*5) %>% 
  pack_rows(group_label = filter_labels[6], start_row = 3*5+1, end_row = 3*6)

write(bacon_table, file = file.path(path_tables, "bacon.tex"))

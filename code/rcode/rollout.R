# load objects
rm(list= ls()[!(ls() %in% ls(all.name = FALSE, pattern = '^path*'))])
load(file = file.path(path_panel, 'filtered_panels.RData'))

rollout <- filtered_base %>% 
  group_by(year_scanned) %>% 
  summarise(length(year_scanned)/9, .groups = 'drop') %>% 
  mutate(year_scanned = ifelse(year_scanned == "never_treated", 
                "Never Treated", 
                substr(year_scanned, 9, nchar(year_scanned)))) %>% 
  arrange(year_scanned) %>% 
  as.data.frame()

colnames(rollout) <- c("Cohort", "Number of Books")
rownames(rollout) <- NULL

rollout_table <- stargazer(rollout, 
          summary = F, 
          rownames = F,
          title = "Treatment Cohorts")

write(rollout_table, file = file.path(path_tables, 'rolly_t.tex'))

# import & filter
# read .dta panels into R
# save as either an .RData bundle of panels OR 
# individual .RDs panels (whatever we decide works)
base <- read_dta(file.path(path_panel, 'base.dta'))
filtered_base <- base %>% 
  as.data.frame()

faculty <- read_dta(file.path(path_panel, 'faculty.dta'))
filtered_fac <- faculty %>% 
  filter(type == "faculty")%>% 
  as.data.frame()

students <-  read_dta(file.path(path_panel, 'students.dta'))
filtered_doc <- students %>% 
  filter(type == "doctor")%>% 
  as.data.frame()
filtered_mas <- students %>% 
  filter(type == "master")%>% 
  as.data.frame()
filtered_und <- students %>% 
  filter(type == "undergrad")%>% 
  as.data.frame()

inbuilding <- read_dta(file.path(path_panel, 'inbuilding.dta'))
filtered_inb <- inbuilding %>% 
  filter(type == "inbuilding")%>% 
  as.data.frame()

# save imported panels
save(file = file.path(path_panel, 'rpanels.RData'), 
     list = c("base", "faculty", "students", "inbuilding"))

# Save filtered panels
save(file = file.path(path_panel, 'filtered_panels.RData'), 
     list = c("filtered_base", "filtered_fac", "filtered_doc", 
              "filtered_mas", "filtered_und", "filtered_inb"))
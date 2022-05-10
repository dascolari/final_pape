# read .dta panels into R
# save as either an .RData bundle of panels OR 
# individual .RDs panels (whatever we decide works)
base <- read_dta(file.path(path_panel, 'base.dta'))
faculty <- read_dta(file.path(path_panel, 'faculty.dta'))
students <-  read_dta(file.path(path_panel, 'students.dta'))
inbuilding <- read_dta(file.path(path_panel, 'inbuilding.dta'))

save(file = file.path(path_panel, 'rpanels.RData'), 
     list = c("base", "faculty", "students", "inbuilding"))

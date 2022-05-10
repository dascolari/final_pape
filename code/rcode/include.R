library(tidyverse)
library(here)
library(fixest)
library(did)
library(haven)
library(bacondecomp)
library(foreach)
library(stargazer)

# quarantine the here() function to this single call 
# makes it easy to work around if bugs pop up
# main paths 
path <- here()

# sub paths
path_panel <- file.path(path, 'data', 'panel_data')
path_models <-  file.path(path, 'output', 'models')
path_tables <- file.path(path, 'output', 'tables')
library(tidyverse)
library(here)
library(fixest)
library(did)
library(haven)
library(bacondecomp)
library(foreach)

# quarantine the here() function to this single call 
# makes it easy to work around if bugs pop up
# main paths 
path <- here()

# sub paths
path_panel <- file.path(path, 'data', 'panel_data')

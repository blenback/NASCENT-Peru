########################################################################
## Script name: 
## Purpose of script:
## Author: 
## Date Created: 2023-10-13
## Notes:
########################################################################

### =========================================================================
### Preparation
### =========================================================================

## Install and load packages

#vector other required packages
packs<-c()

#install new packages
new.packs <- packs[!(packs %in% installed.packages()[, "Package"])]
if (length(new.packs)) install.packages(new.packs)

# Load required packages
invisible(lapply(packs, require, character.only = TRUE))

# Source custom functions
invisible(sapply(list.files("Scripts/Functions",
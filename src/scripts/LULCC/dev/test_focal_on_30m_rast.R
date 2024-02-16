########################################################################
## Script name:  test_focal_on_30m_rast.R
## Purpose of script: Testing time of terra::focal on 30m Mapbiomass LULC data
## Author: Ben Black
## Date Created: 2024-02-16
## Notes:
########################################################################

### =========================================================================
### Preparation
### =========================================================================

## Install and load packages

#vector other required packages
packs<-c("terra")

#install new packages
new.packs <- packs[!(packs %in% installed.packages()[, "Package"])]
if (length(new.packs)) install.packages(new.packs)

# Load required packages
invisible(lapply(packs, require, character.only = TRUE))

# Source custom functions
invisible(sapply(list.files("Scripts/Functions",pattern = ".R",full.names = TRUE,recursive = TRUE),source))



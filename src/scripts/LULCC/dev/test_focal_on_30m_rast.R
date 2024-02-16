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

# path to test layer
test_lyr_path <- "X:/NASCENT-Peru/03_workspaces/02_modelling/Data_collab/LULC/MapBiomas/peru_coverage_1985.tif"

# load test layer
test_lyr <- rast(test_lyr_path)

#start timer
start_time <- Sys.time()

#run focal calc
test_lyr_focal <- focal(test_lyr, w=matrix(1,3,3), fun=mean, na.rm=TRUE)

#end timer
end_time <- Sys.time()

#calculate time
time_taken <- end_time - start_time



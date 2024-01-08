########################################################################
## Script name: convert_stat_to_tif
## Purpose of script: Convert Statistics from INEI to raster files
## Author: Chenyu Shen 
## Date Created: 2023-12-04
## Notes:
########################################################################

### =========================================================================
### A - Preparation
### =========================================================================

## Install and load packages

#vector other required packages
packs<-c("sf", "terra", "dplyr")

#install new packages
new.packs <- packs[!(packs %in% installed.packages()[, "Package"])]
if (length(new.packs)) install.packages(new.packs)

# Load required packages
invisible(lapply(packs, require, character.only = TRUE))

# Set working directory
setwd(Data_dir)

# Load the shapefile of departments in Peru 
peru_departments <- st_read("Preds/Raw/Shapefiles/Departamento/LIM_DEPARTAMENTO.shp")

# Load the population data (assuming it's a CSV file; adjust as needed)
population_data <- read.csv("Population.csv")

# Load the reference raster
template_raster <- rast("utils/ref_grid.tif")


### =========================================================================
### B - Assign Population values as raster values
### =========================================================================

# Merge the shapefile with the population data
# Ensure that both datasets have a common column for merging (e.g., department name)
merged_data <- merge(peru_departments, population_data, by = "NOMBDEP")

# Rasterize the population data
population_raster <- terra::rasterize(merged_data, template_raster, "X2017", fun = sum)

# Export as TIFF
terra::writeRaster(population_raster, "population_map.tif", overwrite = TRUE)

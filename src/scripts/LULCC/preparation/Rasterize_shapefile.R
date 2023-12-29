########################################################################
## Script name: Rasterize_shapefile
## Purpose of script: rasterize the shapefils of three geographical regions in Peru  
## Author: Chenyu Shen
## Date Created: 2023-10-27
## Notes:
########################################################################

### =========================================================================
### A - Preparation
### =========================================================================

## Install and load packages

#vector other required packages
packs<-c("terra")

#install new packages
new.packs <- packs[!(packs %in% installed.packages()[, "Package"])]
if (length(new.packs)) install.packages(new.packs)

# Load required packages
invisible(lapply(packs, require, character.only = TRUE))

# Set working directory
setwd("C:/Work/Peru-env-futures")

# Read in the shapefile
regions <- vect("src/utils/Geographical_Region/region-geografica.shp")

# Read in the reference raster
ref_raster <- rast("src/utils/ref_grid.tif")


### =========================================================================
### B - Check and Transform CRS
### =========================================================================

# Check CRS of both files
crs_regions <- crs(regions)
crs_ref <- crs(ref_raster)

# Transform if necessary
if (crs_regions != crs_ref) {
  regions <- project(regions, crs_ref)
}


### =========================================================================
### C - Rasterize the shapefile
### =========================================================================

# Access and view the attibutes table of the shapefile
attributes <- values(regions)
print(attributes)

# Rasterize
rasterized_regions <- rasterize(regions, ref_raster, field="nombre", fun="min")

# Plot rasterized data
plot(rasterized_regions, col=rainbow(3))

# Overlay vector data (e.g., boundaries or points)
plot(regions, add=TRUE)

writeRaster(rasterized_regions, "src/utils/rasterized_regions.tif")

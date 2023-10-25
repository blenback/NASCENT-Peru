########################################################################
## Script name: Ref_grid_creation
## Purpose of script: Set up uniform spatial grid for project as reference 
## Author: Chenyu Shen
## Date Created: 2023-10-13
## Notes:
########################################################################

### =========================================================================
### A - Preparation
### =========================================================================

## Install and load packages

#vector other required packages
packs<-c("terra","raster")

#install new packages
new.packs <- packs[!(packs %in% installed.packages()[, "Package"])]
if (length(new.packs)) install.packages(new.packs)

# Load required packages
invisible(lapply(packs, require, character.only = TRUE))

# Set working directory
setwd(Data_dir)

# Load one of the LULC layers
input_raster <- rast("LULC/peru_coverage_2021.tif")


### =========================================================================
### B - Extract information and remove unnecessary cells
### =========================================================================

# Extract extent, CRS, and resolution information
extent_info <- ext(input_raster)
crs_info <- crs(input_raster)
res_info <- res(input_raster)
nrows <- nrow(input_raster)
ncols <- ncol(input_raster)


# Create a reference grid with the same extent, CRS, and resolution
ref_grid <- rast(extent_info, nrows = nrows, ncols = ncols, crs = crs_info, vals = NA)

# Define the extent of desired region (xmin, xmax, ymin, ymax)
desired_extent <- c(xmin = -81.81, xmax = -68.15, ymin = -18.80, ymax = 0.32)

# Crop the reference grid to the extent of desired region
cropped_gird <- crop(ref_grid, desired_extent)

# Save the cropped raster 
writeRaster(cropped_gird, "ref_grid.tif", overwrite = TRUE)

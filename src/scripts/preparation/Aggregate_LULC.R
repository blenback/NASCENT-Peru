########################################################################
## Script name: Aggregate_LULC
## Purpose of script: Aggregate the MapBiomas LULC data to 120m resolution
## Author: Chenyu Shen
## Date Created: 2023-11-20
## Notes:
########################################################################

### =========================================================================
### A - Preparation
### =========================================================================

## Install and load packages

#vector other required packages
packs<-c("terra","raster","sp")

#install new packages
new.packs <- packs[!(packs %in% installed.packages()[, "Package"])]
if (length(new.packs)) install.packages(new.packs)

# Load required packages
invisible(lapply(packs, require, character.only = TRUE))

# Set working directory
setwd(Data_dir)

# Set output directory
output_dir <- "LULC/MapBiomas_120m"

### =========================================================================
### B - Aggregate the Data
### =========================================================================
for (year in 1985:2021) {
  # Construct file path for the input raster
  input_path <- sprintf("LULC/MapBiomas/peru_coverage_%d.tif", year)
  
  # Check if the file exists
  if (!file.exists(input_path)) {
    next  # Skip to the next iteration if the file does not exist
  }
  
  # Load the raster
  lulc_30m <- raster(input_path)
  
  # Aggregate to 120m resolution
  agg_factor <- 4  # 30m to 120m needs a factor of 4
  lulc_120m <- aggregate(lulc_30m, fact=agg_factor, fun=modal, na.rm=TRUE)
  
  # Construct file path for the output raster
  output_path <- sprintf("%s/peru_coverage_120m_%d.tif", output_dir, year)
  
  # Save the aggregated raster
  writeRaster(lulc_120m, filename=output_path, overwrite=TRUE)
}
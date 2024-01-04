########################################################################
## Script name: Distance_to_water
## Purpose of script: Calculate the distance from water bodies (navigable rivers, 
## small rivers and streams, lakes and lagoons)
## Author: Chenyu Shen
## Date Created: 2023-11-15
## Notes:
########################################################################

### =========================================================================
### A - Preparation
### =========================================================================

## Install and load packages

#vector other required packages
packs<-c("raster", "sf", "terra")

#install new packages
new.packs <- packs[!(packs %in% installed.packages()[, "Package"])]
if (length(new.packs)) install.packages(new.packs)

# Load required packages
invisible(lapply(packs, require, character.only = TRUE))

# Set working directory
setwd(Data_dir)


# Load the shapefiles of waterbody
navigable_rivers <- st_read("Preds/Raw/Shapefiles/navigable_river/Rio_navegables.shp")
small_rivers <- st_read("Preds/Raw/Shapefiles/river_stream/Rios_Quebradas.shp")
lakes_lagoons <- st_read("Preds/Raw/Shapefiles/lake_lagoon/Lagos_lagunas_Project.shp")

# Load and reproject Peru's boundary to match the CRS of the water body rasters
peru_boundary <- st_read("Preds/Raw/Shapefiles/Country/nivel-politico-1.shp")
template_raster <- rast("ref_grid.tif")
peru_boundary_transformed <- st_transform(peru_boundary, crs = crs(template_raster))

### =========================================================================
### B - Calculate Distance
### =========================================================================

# Rasterize the Shapefiles
raster_navigable_rivers <- rasterize(navigable_rivers, template_raster,field=1)
raster_small_rivers <- rasterize(small_rivers, template_raster,field=1)
raster_lakes_lagoons <- rasterize(lakes_lagoons, template_raster,field=1)  
# field=1 is used to mark the presence of the feature. 
# It's a placeholder to indicate where the features are in the raster grid

# Clip the rasters to Peru's boundary
raster_navigable_rivers_clipped <- mask(raster_navigable_rivers, peru_boundary_transformed)
raster_small_rivers_clipped <- mask(raster_small_rivers, peru_boundary_transformed)
raster_lakes_lagoons_clipped <- mask(raster_lakes_lagoons, peru_boundary_transformed)

# Calculate Distance within Peru's boundary
distance_navigable_rivers <- terra::distance(raster_navigable_rivers_clipped)
distance_small_rivers <- terra::distance(raster_small_rivers_clipped)
distance_lakes_lagoons <- terra::distance(raster_lakes_lagoons_clipped)


# Write the output as Tiff files
writeRaster(distance_navigable_rivers, "distance_navigable_rivers.tif")
writeRaster(distance_small_rivers, "distance_small_rivers.tif")
writeRaster(distance_lakes_lagoons, "distance_lakes_lagoons.tif")

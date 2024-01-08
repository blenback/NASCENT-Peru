library(terra)
library(sf)

# Set working directory
setwd(Data_dir)

# Load the river shapefile with sf
rivers <- st_read("Preds/Raw/Shapefiles/navigable_river/Rio_navegables.shp")

# Convert sf object to SpatVector object
rivers_vect <- vect(rivers)

# Load the reference raster
template_raster <- rast("ref_grid.tif")

# Rasterize the river shapefile
# Create a raster where river cells are 1 and others are NA
rivers_rasterized <- rasterize(rivers_vect, template_raster, field=1)

# Load and reproject Peru's boundary to match the CRS of the water body rasters
peru_boundary <- st_read("Preds/Raw/Shapefiles/Country/nivel-politico-1.shp")
peru_boundary_transformed <- st_transform(peru_boundary, crs = crs(template_raster))

# Clip the rasters to Peru's boundary
rivers_clipped <- mask(rivers_rasterized, peru_boundary_transformed)

# Define a smaller extent 
# obtain the extent of the original raster 
rows <- nrow(rivers_rasterized)
cols <- ncol(rivers_rasterized)

# Calculate the center coordinates of the raster
center_row <- rows / 2
center_col <- cols / 2

# Calculate the start and end rows and columns for cropping
start_row <- center_row - 2128 / 2
end_row <- center_row + 2128 / 2
start_col <- center_col - 1520 / 2  
end_col <- center_col + 1520 / 2

# Convert row and column indices to coordinates
start_x <- xFromCol(rivers_rasterized, start_col)
end_x <- xFromCol(rivers_rasterized, end_col)
start_y <- yFromRow(rivers_rasterized, end_row)
end_y <- yFromRow(rivers_rasterized, start_row)

# Create the extent
small_extent <- terra::ext(start_x, end_x, start_y, end_y)

# Crop the raster
small_raster <- crop(rivers_rasterized, small_extent)

# Calculate the distance from each cell in the template raster to the nearest river
distance_to_river <- distance(small_raster)

# Basic plot with terra
plot(distance_to_river, 
     main="Distance to River", 
     col=viridis::viridis(100), 
     xlab="Longitude", ylab="Latitude")

# Advanced version using ggplot

library(ggplot2)
library(viridis)

# Convert raster to a data frame for ggplot
raster_df <- as.data.frame(distance_to_river, xy=TRUE)

# Use ggplot to plot
ggplot(raster_df, aes(x = x, y = y, fill = layer)) +
  geom_tile() +
  scale_fill_viridis(name="Distance to River", option="D") +
  labs(title="Distance to River", x="Longitude", y="Latitude") +
  coord_fixed()

# Write the output as Tiff files
writeRaster(distance_to_river, "distance_to_river.tif")

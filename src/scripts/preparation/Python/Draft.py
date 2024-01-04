from osgeo import gdal
import matplotlib.pyplot as plt

# Open a raster file
raster_rivers_path = f"./raster_rivers_clipped.tif"
dataset = gdal.Open(raster_rivers_path)

# Get raster band
band = dataset.GetRasterBand(1)

# Read the raster as array
array = band.ReadAsArray()

plt.imshow(array, cmap='gray')  # Change colormap as needed
plt.colorbar()
plt.show()


# Load the rasterized shapefiles of waterbody
# raster_rivers_path = f"./raster_rivers_clipped.tif"
# raster_lagoons_path = f"./raster_lagoons_clipped.tif"

import numpy as np
import geopandas as gpd
import rasterio
from rasterio.warp import calculate_default_transform, reproject, Resampling

# Load and Reproject the River Shapefile
rivers_gdf = gpd.read_file("C:/Users/chshen/OneDrive - ETH Zurich/Work/Peru_data_collab/Preds/Raw/Water/Rios/Rios.shp")
lagoons_gdf = gpd.read_file("C:/Users/chshen/OneDrive - ETH Zurich/Work/Peru_data_collab/Preds/Raw/Water/Lagunas/Lagunas.shp")
# Determine the appropriate UTM zone for Peru and reproject
utm_crs = 'EPSG:24892'  # South American Datum 1969 (SAD69) / Peru Central zone
rivers_gdf_utm = rivers_gdf.to_crs(utm_crs)
lagoons_gdf_utm = lagoons_gdf.to_crs(utm_crs)

# Save the Reprojected River Shapefile
rivers_gdf_utm.to_file('./reprojected_rivers.shp')
lagoons_gdf_utm.to_file('./reprojected_lagoons.shp')

# Load the Template Raster
with rasterio.open("C:/Users/chshen/OneDrive - ETH Zurich/Work/Peru_data_collab/ref_grid.tif") as src:
    transform, width, height = calculate_default_transform(
        src.crs, utm_crs, src.width, src.height, *src.bounds)
    meta = src.meta.copy()
    meta.update({
        'crs': utm_crs,
        'transform': transform,
        'width': width,
        'height': height
    })

    # Reproject the Template Raster
    template = np.full((height, width), np.nan, dtype=rasterio.float32)
    reproject(
        source=rasterio.band(src, 1),
        destination=template,
        src_transform=src.transform,
        src_crs=src.crs,
        dst_transform=transform,
        dst_crs=utm_crs,
        resampling=Resampling.nearest)


# Save the Reprojected Raster
with rasterio.open('./reprojected_raster.tif', 'w', **meta) as dst:
    dst.write(template, 1)

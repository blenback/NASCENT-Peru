import geopandas as gpd
import rasterio
from rasterio.features import rasterize
from scipy.ndimage import distance_transform_edt
import numpy as np
from rasterio.mask import mask

def calculate_distance_to_river(river_shapefile, template_raster_path, meta):
    rivers_gdf = gpd.read_file(river_shapefile)
    with rasterio.open(template_raster_path) as src:
        river_raster = rasterize(
            [(geometry, 1) for geometry in rivers_gdf.geometry],
            out_shape=(src.height, src.width),
            transform=src.transform,
            fill=0,
            all_touched=True,
            dtype='float32'
        )

        # Compute Distance to Nearest River
        inverse_river_raster = np.where(river_raster == 1, 0, 1)
        distance = distance_transform_edt(inverse_river_raster) * src.res[0]

        return distance

# Paths to the reprojected river shapefiles
river_shapefile = './Data/reprojected_rivers.shp'
lagoon_shapefile = './Data/reprojected_lagoons.shp'
template_raster_path = './Data/reprojected_raster.tif'

# Extract metadata from the template raster
with rasterio.open(template_raster_path) as src:
    meta = src.meta.copy()

# Calculate distances
distance_river = calculate_distance_to_river(river_shapefile, template_raster_path, meta)
distance_lagoon = calculate_distance_to_river(lagoon_shapefile, template_raster_path, meta)

# Path Peru boundary shapefile
peru_boundary_gdf = gpd.read_file("C:/Users/chshen/OneDrive - ETH Zurich/Work/Peru_data_collab/Preds/Raw/Peru_admin_boud/per_admbnda_adm0_ign_20200714.shp")
utm_crs = 'EPSG:24892'
peru_boundary_utm = peru_boundary_gdf.to_crs(utm_crs)

# Clip the distance rater to the boundary Peru
def clip_raster_with_shapefile(raster_path, shapefile_path, output_raster_path):
    # Load the boundary shapefile
    boundary_gdf = gpd.read_file(shapefile_path)

    # Load the raster to be clipped
    with rasterio.open(raster_path) as src:
        out_image, out_transform = mask(src, boundary_gdf.geometry, crop=True)
        out_meta = src.meta.copy()

        # Update the metadata to reflect the new raster dimensions
        out_meta.update({"driver": "GTiff",
                         "height": out_image.shape[1],
                         "width": out_image.shape[2],
                         "transform": out_transform})

        # Save the clipped raster
        with rasterio.open(output_raster_path, 'w', **out_meta) as dest:
            dest.write(out_image)

# File paths
clipped_river_raster = 'clipped_river_raster.tif'
clipped_lagoon_raster = 'clipped_lagoon_raster.tif'

# Clip the rasters
clip_raster_with_shapefile(distance_river, peru_boundary_utm, clipped_river_raster)
clip_raster_with_shapefile(distance_lagoon, peru_boundary_utm, clipped_lagoon_raster)



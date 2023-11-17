from owslib.wcs import WebCoverageService
import rasterio
import matplotlib.pyplot as plt
from rasterio import plot

# WCS URLs for different soil properties
wcs_urls = {
    'phh2o': 'http://maps.isric.org/mapserv?map=/map/phh2o.map',
    'bdod': 'http://maps.isric.org/mapserv?map=/map/bdod.map',
    'cec': 'http://maps.isric.org/mapserv?map=/map/cec.map',
    'cfvo': 'https://maps.isric.org/mapserv?map=/map/cfvo.map',
    'clay': 'https://maps.isric.org/mapserv?map=/map/clay.map',
    'nitrogen': 'https://maps.isric.org/mapserv?map=/map/nitrogen.map',
    'sand': 'https://maps.isric.org/mapserv?map=/map/sand.map',
    'silt': 'https://maps.isric.org/mapserv?map=/map/silt.map',
    'soc': 'https://maps.isric.org/mapserv?map=/map/soc.map',
    'ocs': 'https://maps.isric.org/mapserv?map=/map/ocs.map',
    'ocd': 'https://maps.isric.org/mapserv?map=/map/ocd.map'

    # Add other WCS URLs here
    # ...
}

# Soil properties
soil_properties = ['phh2o', 'bdod', 'cec', 'cfvo', 'clay', 'nitrogen', 'sand', 'silt', 'soc', 'ocd', 'ocs']

# Depth intervals
depth_intervals = ['0-5cm', '5-15cm', '15-30cm', '30-60cm', '60-100cm', '100-200cm']

# A bounding box broadly matching Peru
bbox = (-81.81, -18.80, -68.15, 0.32)

for property in soil_properties:
    wcs_url = wcs_urls.get(property, '')
    if wcs_url:
        wcs = WebCoverageService(wcs_url, version='1.0.0')

        for depth in depth_intervals:
            identifier = f'{property}_{depth}_mean'
            file_name = f'./data/{property}_{depth}_mean.tif'
            title = f'Mean {property} between {depth} deep in Peru'

            # Fetch the map segment within the bounding box
            response = wcs.getCoverage(
                identifier=identifier,
                crs='urn:ogc:def:crs:EPSG:4326',
                bbox=bbox,
                resx=0.002, resy=0.002,
                format='GEOTIFF_INT16')

            # Fetch the coverage for Peru and save it to disk
            with open(file_name, 'wb') as file:
                file.write(response.read())
                print(f"download complete: {file_name}")

            # Open the file from disk
            ph = rasterio.open(file_name, driver="GTiff")

            # Use the plot class to plot the map
            plot.show(ph, title=title, cmap='gist_ncar')
            plt.show()
    else:
        print(f"WCS URL for {property} not defined.")

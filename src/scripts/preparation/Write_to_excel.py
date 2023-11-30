import os
import pandas as pd

# Set the directory where your TIF files are located
directory_path = 'C:/Users/chshen/OneDrive - ETH Zurich/Work/Peru_data_collab/Preds/Raw/Soil'
relative_path_root = 'Peru_data_collab/Preds/Raw/Soil'

# List all TIF files in the directory
tif_files = [f for f in os.listdir(directory_path) if f.endswith('.tif')]

# Load existing data from the Excel file
excel_path = "C:/Users/chshen/OneDrive - ETH Zurich/Work/predictor_table.xlsx"  # Replace with the path to your Excel file
existing_data = pd.read_excel(excel_path)

# Append each TIF file path as a new row to the DataFrame
for tif_file in tif_files:
    # Extract the file name without the .tif extension to use as the 'Variable_name'
    variable_name = os.path.splitext(tif_file)[0]

    # Construct the relative file path
    relative_file_path = os.path.join(relative_path_root, tif_file)

    # Define the new data entry
    new_data_entry = {
        'Variable_name': variable_name,
        'Data_citation': 'Soilgrid',
        'URL': 'https://maps.isric.org/',
        'Original_resolution': '250m',
        'Static_or_dynamic': 'static',  # or 'dynamic' based on your data
        'Temporal_coverage': '',
        'Temporal_resolution': '',
        'Prepared': 'No',
        'Raw_data_path': relative_file_path,
        # ... add other fields as necessary
    }

    # Convert the dictionary to a DataFrame to ensure similar structure
    new_data_df = pd.DataFrame([new_data_entry])
    existing_data = pd.concat([existing_data, new_data_df], ignore_index=True)

# Save the updated DataFrame back to an Excel file
existing_data.to_excel(excel_path, index=False)

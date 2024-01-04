
import pandas as pd
import os

def process_file(file_path):
    # Extracting a prefix from the file name (assuming file name format is like 'Copper_reserves.xlsx')
    file_name = os.path.basename(file_path)
    prefix = ''.join([word[0] for word in file_name.split('_')]).lower()

    # Load the Excel file
    df = pd.read_excel(file_path, sheet_name=0, skiprows=4)

    # Rename the first column to 'DEPARTMENT' for clarity
    df.rename(columns={df.columns[0]: 'DEPARTMENT'}, inplace=True)

    # Drop rows at the end that are part of notes and sources if any
    df = df.dropna(subset=['DEPARTMENT'])

    # Replace commas with dots and remove dashes
    df.replace({',': '.', '-': ''}, regex=True, inplace=True)

    # Abbreviate column names from the second column onwards
    columns = df.columns.tolist()
    abbreviated_columns = [columns[0]] + [f'{prefix}_{col}' for col in columns[1:]]
    df.columns = abbreviated_columns

    # Save the updated dataframe to CSV
    output_csv_file_path = file_path.replace('.xlsx', '_processed.csv')
    df.to_csv(output_csv_file_path, index=False)

# Example usage
process_file('path_to_your_excel_file.xlsx')

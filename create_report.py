#!/usr/bin/env python

import pandas as pd
import os
import argparse
import sys

def get_tsv_files_in_directory(directory_path):
    """
    Looks for all files with the '.tsv' suffix in the specified directory
    and returns a list of their full paths.

    Args:
        directory_path (str): The path to the directory to search.

    Returns:
        list: A list of full paths to .tsv files found in the directory.
              Returns an empty list if no .tsv files are found or if the
              directory does not exist.
    """
    tsv_files = []
    if not os.path.isdir(directory_path):
        # Using sys.exit(1) here is appropriate as it's a critical error
        # that prevents the script from functioning correctly.
        print(f"Error: Directory '{directory_path}' not found.", file=sys.stderr)
        sys.exit(1)

    for filename in os.listdir(directory_path):
        if filename.endswith(".tsv"):
            full_path = os.path.join(directory_path, filename)
            tsv_files.append(full_path)
    return tsv_files

if __name__ == "__main__":
    # Create the parser
    parser = argparse.ArgumentParser(
        description="Finds all .tsv files in a specified directory."
    )

    # Add the directory argument
    parser.add_argument(
        "directory",
        type=str,
        help="The path to the directory to scan for .tsv files."
    )

    # Parse the arguments
    args = parser.parse_args()

    # Get the directory path from the parsed arguments
    directory_to_scan = args.directory

    # Get the list of TSV files
    tsv_file_list = get_tsv_files_in_directory(directory_to_scan)

    if tsv_file_list:
        print("Found .tsv files:")
        for file_path in tsv_file_list:
            print(file_path)
    else:
        print(f"No .tsv files found in '{directory_to_scan}'.")

    # Example of how you might use pandas with the list of files:
    # print("\n--- Processing first 5 rows of each TSV file (if any) ---")
    # for tsv_file in tsv_file_list:
    #     try:
    #         # Read the TSV file using pandas
    #         df = pd.read_csv(tsv_file, sep='\t')
    #         print(f"\n--- Data from {os.path.basename(tsv_file)} ---")
    #         # Display the first 5 rows of the DataFrame
    #         print(df.head())
    #     except pd.errors.EmptyDataError:
    #         print(f"Warning: {os.path.basename(tsv_file)} is empty and cannot be read by pandas.", file=sys.stderr)
    #     except Exception as e:
    #         print(f"Error reading {os.path.basename(tsv_file)}: {e}", file=sys.stderr)

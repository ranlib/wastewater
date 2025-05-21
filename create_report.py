#!/usr/bin/env python
"""
Take aquascope directory, loop over tsv files, create report.
"""
import os
import sys
import argparse
import datetime
import pandas


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
    parser = argparse.ArgumentParser(description="Finds all .tsv files in a specified directory.")
    parser.add_argument("--directory", "-f", type=str, required=True, help="The path to the directory to scan for .tsv files.")
    parser.add_argument("--output", "-o", type=str, required=True, help="The name of the output tsv file.")
    parser.add_argument("--debug", "-d", action="store_true", help="Turn on debugging output.")
    args = parser.parse_args()

    directory_to_scan = args.directory

    tsv_file_list = get_tsv_files_in_directory(directory_to_scan)

    if args.debug:
        if tsv_file_list:
            print("Found .tsv files:")
            for file_path in tsv_file_list:
                print(file_path)
        else:
            print(f"No .tsv files found in '{directory_to_scan}'.")

    d_list = []
    for tsv_file in tsv_file_list:
        base_name = os.path.basename(tsv_file)
        name_without_extension, _ = os.path.splitext(base_name)
        timestamp = os.path.getmtime(tsv_file)
        datetime_object = datetime.datetime.fromtimestamp(timestamp)
        pandas_timestamp = pandas.Timestamp(datetime_object)
        try:
            dd = pandas.read_csv(tsv_file, sep="\t", skiprows=1).transpose()
            dd.columns = dd.iloc[0]
            dd = dd[1:]
            dd = dd.reset_index(drop=True)
            dd["sample"] = name_without_extension
            dd["timestamp"] = pandas_timestamp
            dd["lineages"] = dd["lineages"].str.split()
            dd["abundances"] = dd["abundances"].str.split()
            dd = dd.explode(["lineages", "abundances"])
            d_list.append(dd)
        except pandas.errors.EmptyDataError:
            print(f"Warning: {os.path.basename(tsv_file)} is empty and cannot be read by pandas.", file=sys.stderr)
        except Exception as e:
            print(f"Error reading {os.path.basename(tsv_file)}: {e}", file=sys.stderr)

    ddd = pandas.concat(d_list)
    ddd = ddd.reset_index(drop=True)

    cols = ["source", "jurisdiction_policy_rid", "reporting_jurisdiction", "wwtp_jurisdiction", "key_plot_with_pcr", "sample_collect_date", "sample_id", "qc_threshold", "dominant_voc", "aggregated_lineage", "lineage", "abundance", "time_analyzed", "time_analyzed_tz"]
    df = pandas.DataFrame(columns=cols)
    df["source"] = ["CDPH_CovidSeq"] * len(ddd.index)
    df["reporting_jurisdiction"] = ["ca"] * len(ddd.index)
    df["wwtp_jurisdiction"] = ["ca"] * len(ddd.index)
    df["sample_id"] = ddd["sample"].copy()
    df["lineage"] = ddd["lineages"].copy()
    df["abundance"] = ddd["abundances"].copy()
    df["time_analyzed"] = ddd["timestamp"].copy()
    df = df.reset_index(drop=True)
    df.to_csv(args.output, sep="\t", index=False)
    df.to_excel(args.output.replace(".tsv", ".xlsx"), index=False)

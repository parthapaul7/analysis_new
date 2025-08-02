#!/bin/bash

# Check if folder argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <folder>"
    exit 1
fi

FOLDER="$1"

# Check if the specified folder exists
if [ ! -d "$FOLDER" ]; then
    echo "Error: Folder '$FOLDER' not found!"
    exit 1
fi

# Change to the specified directory
cd "$FOLDER" || exit

# Create results directory if it doesn't exist
mkdir -p results

# Loop through POSCAR files from POSCAR to POSCAR20
for i in {-5..29}; do
    input_file="POSCAR$i"
    output_file="results/out$i.txt"
    
    # Check if the input file exists before running the command
    if [[ -f "$input_file" ]]; then
        s-dftd3 -i vasp "$input_file" --zero pbe  --property --verbose  > "$output_file"
        echo "Processed $input_file -> $output_file"
    else
        echo "Skipping $input_file (not found)"
    fi
done

#!/bin/bash

# Create CSV file with headers
echo "cell_length,CN_C,CN_A,C6_C,C6_A,Edis" > output.csv

# Loop through folders E_-5 to E_12
for i in {-5..29}; do
    output_file="results/out$i.txt"  # Adjusted index for out files

    # Extract cell length from CONTCAR
    cell_length=$(awk 'NR==3 {print $1}' "POSCAR$i")


    # Extract CN and C6 values from output file
    if [[ -f "$output_file" ]]; then
        CN_cation=$(awk '$3 == "Li" {print $4; exit}' "$output_file")  # First row CN
        C6_cation=$(awk '$3 == "Li" {print $5; exit}' "$output_file")  # First row CN
	echo "$CN_cation"

        CN_anion=$(awk '$3 == "Ag" {print $4; exit}' "$output_file")  # First row CN
        C6_anion=$(awk '$3 == "Ag" {print $5; exit}' "$output_file")  # First row CN

        dispersion_energy=$(grep "Dispersion energy:" "$output_file" | awk '{print $3}')
    else
        CN_cation="N/A"
        C6_cation="N/A"
        CN_anion="N/A"
        C6_anion="N/A"
        dispersion_energy="N/A"
    fi

    # Append values to CSV file
    echo "$cell_length,$CN_cation,$CN_anion,$C6_cation,$C6_anion,$dispersion_energy" >> output.csv
done

echo "CSV file generated: output.csv"

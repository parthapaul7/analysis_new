#!/bin/bash
# Original structure file
input_file="POSCAR"

# Read lattice vectors from POSCAR (lines 3, 4, 5)
read -r cell_len11 cell_len12 cell_len13 < <(awk 'NR==3 {print $1, $2, $3}' "$input_file")
read -r cell_len21 cell_len22 cell_len23 < <(awk 'NR==4 {print $1, $2, $3}' "$input_file")
read -r cell_len31 cell_len32 cell_len33 < <(awk 'NR==5 {print $1, $2, $3}' "$input_file")

# Function to increment the cell length values
increment_cell_length() {
    local base_value=$1
    local scaling=$2
    awk -v base="$base_value" -v scale="$scaling" 'BEGIN { printf "%.10f", base + scale }'
}

# Loop to create new structure files with incremented cell lengths
for ((i=-5; i<30; i++)); do
    scale=$(echo "0.05 * $i" | bc -l)

    new_cell_len11=$(increment_cell_length "$cell_len11" "$(echo "$scale * $cell_len11" | bc -l)")
    new_cell_len12=$(increment_cell_length "$cell_len12" "$(echo "$scale * $cell_len12" | bc -l)")
    new_cell_len13=$(increment_cell_length "$cell_len13" "$(echo "$scale * $cell_len13" | bc -l)")

    new_cell_len21=$(increment_cell_length "$cell_len21" "$(echo "$scale * $cell_len21" | bc -l)")
    new_cell_len22=$(increment_cell_length "$cell_len22" "$(echo "$scale * $cell_len22" | bc -l)")
    new_cell_len23=$(increment_cell_length "$cell_len23" "$(echo "$scale * $cell_len23" | bc -l)")

    new_cell_len31=$(increment_cell_length "$cell_len31" "$(echo "$scale * $cell_len31" | bc -l)")
    new_cell_len32=$(increment_cell_length "$cell_len32" "$(echo "$scale * $cell_len32" | bc -l)")
    new_cell_len33=$(increment_cell_length "$cell_len33" "$(echo "$scale * $cell_len33" | bc -l)")

    output_file="POSCAR$i"

    # Replace lines 3–5 in POSCAR and write to new file
    awk -v a11="$new_cell_len11" -v a12="$new_cell_len12" -v a13="$new_cell_len13" \
        -v a21="$new_cell_len21" -v a22="$new_cell_len22" -v a23="$new_cell_len23" \
        -v a31="$new_cell_len31" -v a32="$new_cell_len32" -v a33="$new_cell_len33" \
        '{
            if (NR == 3)
                printf "%18.10f %18.10f %18.10f\n", a11, a12, a13;
            else if (NR == 4)
                printf "%18.10f %18.10f %18.10f\n", a21, a22, a23;
            else if (NR == 5)
                printf "%18.10f %18.10f %18.10f\n", a31, a32, a33;
            else
                print
        }' "$input_file" > "$output_file"

    echo "Created $output_file with scaled lattice vectors (scale = $scale)"
done

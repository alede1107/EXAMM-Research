#!/bin/bash

BASE="/anvil/scratch/x-aperdomo/results/701515_split_250"
OUT="/anvil/scratch/x-aperdomo/best_genomes"

mkdir -p "$OUT"

for stock in $(ls $BASE); do
    for folder in $(seq 0 24); do
        DIR="$BASE/$stock/lr_0.001/max_genome_10000/island_10/$folder"

        if [ -f "$DIR/fitness_log.csv" ]; then
            BEST_ID=$(awk -F',' 'NR>1 {if(min=="" || $2<min){min=$2; id=$1}} END{print id}' "$DIR/fitness_log.csv")
            FILE="$DIR/rnn_genome_${BEST_ID}.bin"

            if [ -f "$FILE" ]; then
                cp "$FILE" "$OUT/${stock}_${folder}.bin"
            fi
        fi
    done
done

echo "Done collecting best genomes"

#!/bin/bash

BASE="/anvil/scratch/x-aperdomo/results/701515_split_250"
OUT="/home/x-aperdomo/final_results"

mkdir -p "$OUT"

for STOCK in AKAM NDSN
do
    mkdir -p "$OUT/$STOCK"

    for FOLDER in $(seq 0 24)
    do
        DIR="$BASE/$STOCK/lr_0.001/max_genome_10000/island_10/$FOLDER"

        if [ -f "$DIR/fitness_log.csv" ]; then
            cp "$DIR/fitness_log.csv" "$OUT/$STOCK/${STOCK}_${FOLDER}_fitness_log.csv"

            BEST_GLOBAL=$(find "$DIR" -maxdepth 1 -name 'global_best_genome_*.bin' | sort | tail -n 1)

            if [ -n "$BEST_GLOBAL" ]; then
                cp "$BEST_GLOBAL" "$OUT/$STOCK/${STOCK}_${FOLDER}_best_genome.bin"
            else
                BEST_ID=$(awk -F',' 'NR>1 {if(min=="" || $2<min){min=$2; id=$1}} END{print id}' "$DIR/fitness_log.csv")
                if [ -f "$DIR/rnn_genome_${BEST_ID}.bin" ]; then
                    cp "$DIR/rnn_genome_${BEST_ID}.bin" "$OUT/$STOCK/${STOCK}_${FOLDER}_best_genome.bin"
                fi
            fi
        fi
    done
done

echo "Saved needed outputs to $OUT"

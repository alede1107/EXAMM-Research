#!/bin/bash

OUT="/home/x-aperdomo/final_results"
MIN_LINES=9800

BASES=(
    "/anvil/projects/x-cis251123/aperdomo/results/701515_split_250"
    "/anvil/projects/x-cis251123/aperdomo/results/701515_split_250_recovery"
    "/anvil/projects/x-cis251123/aperdomo/results/701515_split_250_akam_rerun"
)

STOCKS=(
    'NDSN' 'HOLX' 'ATO' 'KIM' 'NVR' 'DPZ' 'JBHT' 'DECK' 'FRT' 'KMX'
    'EXR' 'LNT' 'CINF' 'ED' 'REG' 'CPB' 'LH' 'TRMB' 'DVA' 'PKG'
    'CAG' 'NTRS' 'KMB' 'TRV' 'RHI' 'UHS' 'EMN' 'PODD' 'TECH' 'EXPD'
    'WRB' 'EIX' 'STLD' 'BXP' 'CHRW' 'IVZ' 'HSIC' 'TFX' 'AKAM' 'JKHY'
    'HBAN' 'ESS' 'ETR' 'FFIV' 'CPT' 'IEX' 'IRM' 'COO' 'MHK' 'FDS'
)

mkdir -p "$OUT"
MANIFEST="$OUT/harvest_manifest.csv"
echo "stock,fold,status,fitness_lines,source_dir,best_genome" > "$MANIFEST"

fitness_complete() {
    local fitlog=$1
    [ -f "$fitlog" ] || return 1
    local lines
    lines=$(wc -l < "$fitlog")
    [ "$lines" -ge "$MIN_LINES" ]
}

copy_fold() {
    local stock=$1
    local folder=$2
    local dir=$3
    local fitlog="$dir/fitness_log.csv"
    local lines
    local best_global
    local best_file

    lines=$(wc -l < "$fitlog")
    cp "$fitlog" "$OUT/$stock/${stock}_${folder}_fitness_log.csv"

    best_global=$(find "$dir" -maxdepth 1 -name 'global_best_genome_*.bin' | sort -V | tail -n 1)
    if [ -n "$best_global" ]; then
        best_file="$best_global"
    else
        best_file=$(find "$dir" -maxdepth 1 -name 'rnn_genome_*.bin' | sort -V | tail -n 1)
    fi

    if [ -n "$best_file" ]; then
        cp "$best_file" "$OUT/$stock/${stock}_${folder}_best_genome.bin"
        echo "$stock,$folder,copied,$lines,$dir,$best_file" >> "$MANIFEST"
    else
        echo "$stock,$folder,missing_best_genome,$lines,$dir," >> "$MANIFEST"
    fi
}

for STOCK in "${STOCKS[@]}"; do
    mkdir -p "$OUT/$STOCK"

    for FOLDER in $(seq 0 24); do
        copied=0
        for BASE in "${BASES[@]}"; do
            DIR="$BASE/$STOCK/lr_0.001/max_genome_10000/island_10/$FOLDER"
            if fitness_complete "$DIR/fitness_log.csv"; then
                copy_fold "$STOCK" "$FOLDER" "$DIR"
                copied=1
                break
            fi
        done

        if [ "$copied" -eq 0 ]; then
            echo "$STOCK,$FOLDER,missing_or_incomplete,,,,">> "$MANIFEST"
        fi
    done
done

echo "Saved needed outputs to $OUT"
echo "Manifest: $MANIFEST"

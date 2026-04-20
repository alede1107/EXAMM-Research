#!/bin/bash

script_path="/home/x-aperdomo/examm_scripts"
file_type="250"
MAX_QUEUED=100
USER=x-aperdomo
RESULTS_ROOT="/anvil/projects/x-cis251123/aperdomo/results/701515_split_250"
MIN_LINES=9800

STOCKS=(
    'HOLX' 'ATO' 'KIM' 'NVR' 'DPZ' 'JBHT' 'DECK' 'FRT' 'KMX' 'EXR'
    'LNT' 'CINF' 'ED' 'REG' 'CPB' 'LH' 'TRMB' 'DVA' 'PKG' 'CAG'
    'NTRS' 'KMB' 'TRV' 'RHI' 'UHS' 'EMN' 'PODD' 'TECH' 'EXPD' 'WRB'
    'EIX' 'STLD' 'BXP' 'CHRW' 'IVZ' 'HSIC' 'TFX' 'AKAM' 'JKHY' 'HBAN'
    'ESS' 'ETR' 'FFIV' 'CPT' 'IEX' 'IRM' 'COO' 'MHK' 'FDS'
)

wait_for_queue_space() {
    while true; do
        queued=$(squeue -u "$USER" -h | wc -l)
        if [ "$queued" -lt "$MAX_QUEUED" ]; then
            return 0
        fi
        echo "Queue at $queued/$MAX_QUEUED, sleeping 60s..."
        sleep 60
    done
}

count=0
skipped=0
for DATASET in "${STOCKS[@]}"; do
    for FOLDER in {0..24}; do
        fitlog="${RESULTS_ROOT}/${DATASET}/lr_0.001/max_genome_10000/island_10/${FOLDER}/fitness_log.csv"
        if [ -f "$fitlog" ]; then
            lines=$(wc -l < "$fitlog")
            if [ "$lines" -ge "$MIN_LINES" ]; then
                skipped=$((skipped+1))
                continue
            fi
        fi
        wait_for_queue_space
        script="${script_path}/${file_type}/${file_type}_${DATASET}_${FOLDER}.sh"
        if [ ! -f "$script" ]; then
            echo "MISSING: $script" >&2
            continue
        fi
        sbatch "$script"
        count=$((count+1))
    done
done

echo "Submitted $count jobs, skipped $skipped already-complete folds"

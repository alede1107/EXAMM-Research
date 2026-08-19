#!/bin/bash

script_path="/home/x-aperdomo/examm_scripts"
file_type="250"
MAX_QUEUED=${MAX_QUEUED:-50}
MAX_SUBMIT=${MAX_SUBMIT:-}
DRY_RUN=${DRY_RUN:-0}
JOBLIST=${JOBLIST:-}
USER=x-aperdomo
FINAL_ROOT="/home/x-aperdomo/final_results"
MIN_LINES=9800

RESULT_ROOTS=(
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

QUEUED_NAMES=$(squeue -u "$USER" -h -o "%j" | sort -u)

fitness_complete() {
    local fitlog=$1
    [ -f "$fitlog" ] || return 1
    local lines
    lines=$(wc -l < "$fitlog")
    [ "$lines" -ge "$MIN_LINES" ]
}

has_best_genome() {
    local dir=$1
    compgen -G "$dir/global_best_genome_*.bin" >/dev/null && return 0
    compgen -G "$dir/rnn_genome_*.bin" >/dev/null
}

final_complete() {
    local stock=$1
    local folder=$2
    local fitlog="${FINAL_ROOT}/${stock}/${stock}_${folder}_fitness_log.csv"
    local genome="${FINAL_ROOT}/${stock}/${stock}_${folder}_best_genome.bin"
    fitness_complete "$fitlog" && [ -f "$genome" ]
}

raw_complete() {
    local stock=$1
    local folder=$2
    local root dir fitlog

    for root in "${RESULT_ROOTS[@]}"; do
        dir="${root}/${stock}/lr_0.001/max_genome_10000/island_10/${folder}"
        fitlog="${dir}/fitness_log.csv"
        if fitness_complete "$fitlog" && has_best_genome "$dir"; then
            return 0
        fi
    done

    return 1
}

job_in_queue() {
    local stock=$1
    local folder=$2
    local job_name="${file_type}_${stock}_${folder}"
    printf '%s\n' "$QUEUED_NAMES" | grep -Fxq "$job_name"
}

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
queued_skipped=0
[ -n "$JOBLIST" ] && : > "$JOBLIST"
for DATASET in "${STOCKS[@]}"; do
    for FOLDER in {0..24}; do
        if final_complete "$DATASET" "$FOLDER" || raw_complete "$DATASET" "$FOLDER"; then
            skipped=$((skipped+1))
            continue
        fi

        if job_in_queue "$DATASET" "$FOLDER"; then
            queued_skipped=$((queued_skipped+1))
            continue
        fi

        if [ -n "$MAX_SUBMIT" ] && [ "$count" -ge "$MAX_SUBMIT" ]; then
            echo "Reached MAX_SUBMIT=$MAX_SUBMIT; submitted/listed $count jobs, skipped $skipped already-complete folds, skipped $queued_skipped queued folds"
            exit 0
        fi

        script="${script_path}/${file_type}/${file_type}_${DATASET}_${FOLDER}.sh"
        if [ ! -f "$script" ]; then
            echo "MISSING: $script" >&2
            continue
        fi
        if [ -n "$JOBLIST" ]; then
            echo "$script" >> "$JOBLIST"
        elif [ "$DRY_RUN" = "1" ]; then
            echo "DRY_RUN would submit: $script"
        else
            wait_for_queue_space
            sbatch "$script"
        fi
        count=$((count+1))
    done
done

echo "Submitted/listed $count jobs, skipped $skipped already-complete folds, skipped $queued_skipped queued folds"

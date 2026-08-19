#!/bin/bash -l

#SBATCH -J 250_JKHY_14
#SBATCH -A cis251123
#SBATCH -o /home/x-aperdomo/examm_scripts/examm_%x_%j.output
#SBATCH -e /home/x-aperdomo/examm_scripts/examm_%x_%j.error
#SBATCH --mail-user=dp996@njit.edu
#SBATCH --mail-type=ALL
#SBATCH -t 04:00:00
#SBATCH -p shared
#SBATCH -N 1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

STOCK=JKHY
FOLDER=14
INPUT_PARAMETER="RET VOL_CHANGE BA_SPREAD ILLIQUIDITY sprtrn TURNOVER"
EXAMM="/home/x-aperdomo/code/EXAMM-Extended"
DATAPATH="/anvil/projects/x-cis251123/aperdomo/datasets/701515_split"
MAX_GENOME=10000
NUM_ISLAND=10
DATASET=701515_split
lr=0.001
offset=1

final_exp_name="/anvil/projects/x-cis251123/aperdomo/results/701515_split_250_recovery/JKHY/lr_$lr/max_genome_$MAX_GENOME/island_$NUM_ISLAND/$FOLDER"
mkdir -p "$final_exp_name"

JOB_ID_PART="${SLURM_ARRAY_JOB_ID:-$SLURM_JOB_ID}"
TASK_ID_PART="${SLURM_ARRAY_TASK_ID:-$SLURM_JOB_ID}"
JOB_TMP="${TMPDIR:-/tmp}/examm_${JOB_ID_PART}_${TASK_ID_PART}_${STOCK}_${FOLDER}"
LOCAL_DATA="$JOB_TMP/data"
LOCAL_OUT="$JOB_TMP/out"
rm -rf "$JOB_TMP"
mkdir -p "$LOCAL_DATA" "$LOCAL_OUT"
trap 'rm -rf "$JOB_TMP"' EXIT
cp "$DATAPATH/JKHY_train.csv" "$LOCAL_DATA/"
cp "$DATAPATH/JKHY_val.csv" "$LOCAL_DATA/"

echo "Iteration: $final_exp_name (staged to $TMPDIR)"
echo "###-------------------###"

export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export MKL_NUM_THREADS=1

time srun -n "$SLURM_NTASKS" --cpu-bind=cores "$EXAMM/build/mpi/examm_mpi" \
    --training_filenames "$LOCAL_DATA/JKHY_train.csv" \
    --test_filenames "$LOCAL_DATA/JKHY_val.csv" \
    --time_offset $offset \
    --input_parameter_names $INPUT_PARAMETER \
    --output_parameter_names "RET" \
    --number_islands $NUM_ISLAND \
    --island_size 10 \
    --max_genomes $MAX_GENOME \
    --bp_iterations 20 \
    --possible_node_types simple UGRNN MGU GRU delta LSTM \
    --normalize avg_std_dev \
    --extinction_event_generation_number 500 \
    --repeat_extinction \
    --island_ranking_method "EraseWorst" \
    --repopulation_method "bestGenome" \
    --islands_to_exterminate 1 \
    --train_sequence_length 250 \
    --num_mutations 2 \
    --learning_rate $lr \
    --std_message_level INFO \
    --file_message_level INFO \
    --output_directory "$LOCAL_OUT"

if [ -f "$LOCAL_OUT/fitness_log.csv" ]; then
    cp "$LOCAL_OUT/fitness_log.csv" "$final_exp_name/"
fi

copied_best=0
while IFS= read -r best_global; do
    cp "$best_global" "$final_exp_name/"
    copied_best=1
done < <(find "$LOCAL_OUT" -maxdepth 1 -name 'global_best_genome_*.bin' | sort -V)

if [ "$copied_best" -eq 0 ]; then
    best_rnn=$(find "$LOCAL_OUT" -maxdepth 1 -name 'rnn_genome_*.bin' | sort -V | tail -n 1)
    if [ -n "$best_rnn" ]; then
        cp "$best_rnn" "$final_exp_name/"
    fi
fi

echo "Copied fitness_log.csv and best genome bins from $LOCAL_OUT to $final_exp_name"

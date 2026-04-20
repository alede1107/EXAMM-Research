#!/bin/bash -l

#SBATCH -J 250_DECK_9
#SBATCH -A cis251123
#SBATCH -o /home/x-aperdomo/examm_scripts/examm_%x_%j.output
#SBATCH -e /home/x-aperdomo/examm_scripts/examm_%x_%j.error
#SBATCH --mail-user=dp996@njit.edu
#SBATCH --mail-type=ALL
#SBATCH -t 02:30:00
#SBATCH -p standard
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem=48G

STOCK=DECK
FOLDER=9
INPUT_PARAMETER="RET VOL_CHANGE BA_SPREAD ILLIQUIDITY sprtrn TURNOVER"
EXAMM="/home/x-aperdomo/code/EXAMM-Extended"
DATAPATH="/anvil/projects/x-cis251123/aperdomo/datasets/701515_split"
MAX_GENOME=10000
NUM_ISLAND=10
DATASET=701515_split
lr=0.001
offset=1

exp_name="/anvil/projects/x-cis251123/aperdomo/results/701515_split_250/DECK/lr_$lr/max_genome_$MAX_GENOME/island_$NUM_ISLAND/$FOLDER"
mkdir -p "$exp_name"
echo "Iteration: $exp_name"
echo "###-------------------###"

time srun "$EXAMM/build/mpi/examm_mpi" \
    --training_filenames "$DATAPATH/DECK_train.csv" \
    --test_filenames "$DATAPATH/DECK_val.csv" \
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
    --output_directory "$exp_name"

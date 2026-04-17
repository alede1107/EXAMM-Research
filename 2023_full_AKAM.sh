#!/bin/bash -l

#SBATCH -J 2023_full_AKAM
#SBATCH -A cis251123
#SBATCH -o examm_%x_%j.output
#SBATCH -e examm_%x_%j.error
#SBATCH --mail-user=dp996@njit.edu
#SBATCH --mail-type=ALL
#SBATCH -t 4:40:00
#SBATCH -p standard
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem=48G

STOCK=AKAM
INPUT_PARAMETER="RET  VOL_CHANGE  BA_SPREAD  ILLIQUIDITY sprtrn TURNOVER"
EXAMM="/home/x-aperdomo/code/EXAMM-Extended"
DATAPATH="/anvil/scratch/x-aperdomo/datasets/701515_split"
MAX_GENOME=10000
NUM_ISLAND=10
DATASET=701515_split
lr=0.001
offset=1
    for folder in 15 16 17 18 19 20 21 22 23 24
    do
        # REPOPULATION_METHOD = "bestGenome"
        exp_name="/anvil/scratch/x-aperdomo/results/701515_split_2023_full/AKAM/lr_$lr/max_genome_$MAX_GENOME/island_$NUM_ISLAND/$folder"
        mkdir -p $exp_name
        echo "Iteration: $exp_name"
        echo "###-------------------###"
        time srun  $EXAMM/build/mpi/examm_mpi \
        --training_filenames "$DATAPATH/AKAM_train.csv"  \
        --test_filenames "$DATAPATH/AKAM_val.csv" \
        --time_offset $offset \
        --input_parameter_names $INPUT_PARAMETER  \
        --output_parameter_names "RET"\
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
        --num_mutations 2 \
        --learning_rate $lr \
        --std_message_level INFO \
        --file_message_level INFO \
        --output_directory "$exp_name"

    done

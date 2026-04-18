import os

stock_names = [
    'NDSN', 'HOLX', 'ATO', 'KIM', 'NVR', 'DPZ', 'JBHT', 'DECK', 'FRT', 'KMX',
    'EXR', 'LNT', 'CINF', 'ED', 'REG', 'CPB', 'LH', 'TRMB', 'DVA', 'PKG',
    'CAG', 'NTRS', 'KMB', 'TRV', 'RHI', 'UHS', 'EMN', 'PODD', 'TECH', 'EXPD',
    'WRB', 'EIX', 'STLD', 'BXP', 'CHRW', 'IVZ', 'HSIC', 'TFX', 'AKAM', 'JKHY',
    'HBAN', 'ESS', 'ETR', 'FFIV', 'CPT', 'IEX', 'IRM', 'COO', 'MHK', 'FDS'
]

dataset = "701515_split"
experiment_type = "250"
learning_rate = 0.001
normalization_method = "avg_std_dev"
train_length = experiment_type
result_folder = f"{dataset}_{experiment_type}"

scripts_directory = f"/home/x-aperdomo/examm_scripts/{experiment_type}"
os.makedirs(scripts_directory, exist_ok=True)

ACCOUNT = "cis251123"
PARTITION = "standard"
EMAIL = "dp996@njit.edu"
EXAMM = "/home/x-aperdomo/code/EXAMM-Extended"
DATAPATH = "/anvil/scratch/x-aperdomo/datasets/701515_split"
RESULTS_ROOT = "/anvil/scratch/x-aperdomo/results"

for name in stock_names:
    for folder in range(25):
        bash_commands = f"""#!/bin/bash -l

#SBATCH -J {experiment_type}_{name}_{folder}
#SBATCH -A {ACCOUNT}
#SBATCH -o /home/x-aperdomo/examm_scripts/examm_%x_%j.output
#SBATCH -e /home/x-aperdomo/examm_scripts/examm_%x_%j.error
#SBATCH --mail-user={EMAIL}
#SBATCH --mail-type=ALL
#SBATCH -t 00:30:00
#SBATCH -p {PARTITION}
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem=48G

STOCK={name}
FOLDER={folder}
INPUT_PARAMETER="RET VOL_CHANGE BA_SPREAD ILLIQUIDITY sprtrn TURNOVER"
EXAMM="{EXAMM}"
DATAPATH="{DATAPATH}"
MAX_GENOME=10000
NUM_ISLAND=10
DATASET={dataset}
lr={learning_rate}
offset=1

exp_name="{RESULTS_ROOT}/{result_folder}/{name}/lr_$lr/max_genome_$MAX_GENOME/island_$NUM_ISLAND/$FOLDER"
mkdir -p "$exp_name"
echo "Iteration: $exp_name"
echo "###-------------------###"

time srun "$EXAMM/build/mpi/examm_mpi" \\
    --training_filenames "$DATAPATH/{name}_train.csv" \\
    --test_filenames "$DATAPATH/{name}_val.csv" \\
    --time_offset $offset \\
    --input_parameter_names $INPUT_PARAMETER \\
    --output_parameter_names "RET" \\
    --number_islands $NUM_ISLAND \\
    --island_size 10 \\
    --max_genomes $MAX_GENOME \\
    --bp_iterations 20 \\
    --possible_node_types simple UGRNN MGU GRU delta LSTM \\
    --normalize {normalization_method} \\
    --extinction_event_generation_number 500 \\
    --repeat_extinction \\
    --island_ranking_method "EraseWorst" \\
    --repopulation_method "bestGenome" \\
    --islands_to_exterminate 1 \\
    --train_sequence_length {train_length} \\
    --num_mutations 2 \\
    --learning_rate $lr \\
    --std_message_level INFO \\
    --file_message_level INFO \\
    --output_directory "$exp_name"
"""
        script_filename = f"{scripts_directory}/{experiment_type}_{name}_{folder}.sh"
        with open(script_filename, "w") as bash_script:
            bash_script.write(bash_commands)

        print(f"Created: {script_filename}")

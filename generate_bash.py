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
PARTITION = "shared"
EMAIL = "dp996@njit.edu"
EXAMM = "/home/x-aperdomo/code/EXAMM-Extended"
DATAPATH = "/anvil/projects/x-cis251123/aperdomo/datasets/701515_split"
RESULTS_ROOT = "/anvil/projects/x-cis251123/aperdomo/results"
RECOVERY_RESULT_FOLDER = f"{result_folder}_recovery"
NTASKS = 8
MEMORY = "8G"
WALLTIME = "04:00:00"

for name in stock_names:
    for folder in range(25):
        bash_commands = f"""#!/bin/bash -l

#SBATCH -J {experiment_type}_{name}_{folder}
#SBATCH -A {ACCOUNT}
#SBATCH -o /home/x-aperdomo/examm_scripts/examm_%x_%j.output
#SBATCH -e /home/x-aperdomo/examm_scripts/examm_%x_%j.error
#SBATCH --mail-user={EMAIL}
#SBATCH --mail-type=ALL
#SBATCH -t {WALLTIME}
#SBATCH -p {PARTITION}
#SBATCH -N 1
#SBATCH --ntasks={NTASKS}
#SBATCH --cpus-per-task=1
#SBATCH --mem={MEMORY}

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

final_exp_name="{RESULTS_ROOT}/{RECOVERY_RESULT_FOLDER}/{name}/lr_$lr/max_genome_$MAX_GENOME/island_$NUM_ISLAND/$FOLDER"
mkdir -p "$final_exp_name"

JOB_ID_PART="${{SLURM_ARRAY_JOB_ID:-$SLURM_JOB_ID}}"
TASK_ID_PART="${{SLURM_ARRAY_TASK_ID:-$SLURM_JOB_ID}}"
JOB_TMP="${{TMPDIR:-/tmp}}/examm_${{JOB_ID_PART}}_${{TASK_ID_PART}}_${{STOCK}}_${{FOLDER}}"
LOCAL_DATA="$JOB_TMP/data"
LOCAL_OUT="$JOB_TMP/out"
rm -rf "$JOB_TMP"
mkdir -p "$LOCAL_DATA" "$LOCAL_OUT"
trap 'rm -rf "$JOB_TMP"' EXIT
cp "$DATAPATH/{name}_train.csv" "$LOCAL_DATA/"
cp "$DATAPATH/{name}_val.csv" "$LOCAL_DATA/"

echo "Iteration: $final_exp_name (staged to $TMPDIR)"
echo "###-------------------###"

export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export MKL_NUM_THREADS=1

time srun -n "$SLURM_NTASKS" --cpu-bind=cores "$EXAMM/build/mpi/examm_mpi" \\
    --training_filenames "$LOCAL_DATA/{name}_train.csv" \\
    --test_filenames "$LOCAL_DATA/{name}_val.csv" \\
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
"""
        script_filename = f"{scripts_directory}/{experiment_type}_{name}_{folder}.sh"
        with open(script_filename, "w") as bash_script:
            bash_script.write(bash_commands)

        print(f"Created: {script_filename}")

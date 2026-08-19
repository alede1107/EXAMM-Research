#!/bin/bash -l

#SBATCH -J examm_250_array
#SBATCH -A cis251123
#SBATCH -o /home/x-aperdomo/examm_scripts/examm_array_%A_%a.output
#SBATCH -e /home/x-aperdomo/examm_scripts/examm_array_%A_%a.error
#SBATCH --mail-user=dp996@njit.edu
#SBATCH --mail-type=END,FAIL
#SBATCH -t 04:00:00
#SBATCH -p shared
#SBATCH -N 1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

JOBLIST=${JOBLIST:-/home/x-aperdomo/examm_scripts/missing_jobs_latest.txt}

SCRIPT=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$JOBLIST")
if [ -z "$SCRIPT" ]; then
    echo "No script found for array task ${SLURM_ARRAY_TASK_ID} in $JOBLIST" >&2
    exit 1
fi

echo "Array task ${SLURM_ARRAY_TASK_ID} running $SCRIPT"
bash "$SCRIPT"

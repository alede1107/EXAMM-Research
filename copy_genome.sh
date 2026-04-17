#!/bin/bash -l
# NOTE the -l flag!
#

# This is an example job file for a Serial Multi-Process job.
# Note that all of the following statements below that begin
# with #SBATCH are actually commands to the SLURM scheduler.
# Please copy this file to your home directory and modify it
# to suit your needs.
# 
# If you need any help, please email rc-help@rit.edu
#

# Name of the job - You'll probably want to customize this.
#SBATCH -J copy

#SBATCH -A examm

# Standard out and Standard Error output files
#SBATCH -o examm_%x_%j.output
#SBATCH -e examm_%x_%j.error

#To send emails, set the adcdress below and remove one of the "#" signs.
#SBATCH --mail-user=zl7069@rit.edu

# notify on state change: BEGIN, END, FAIL or ALL
#SBATCH --mail-type=ALL

# Request 5 hours run time MAX, anything over will be KILLED
#SBATCH -t 1:0:0

# Put the job in the "work" partition and request FOUR cores for one task
# "work" is the default partition so it can be omitted without issue.

## Please not that each node on the cluster is 36 cores
#SBATCH -p tier3 -n 1

# Job memory requirements in MB
#SBATCH --mem-per-cpu=1000



#module load module_future
#module load openmpi-1.10-x86_64
#module load openmpi
#module load gcc
# spack load gcc@9.3.0/hufzekvjj
# spack load openmpi@4.0.5/f77pdq5

# EXAMM="/home/zl7069/git/onenet_repopulation/exact/results/onenet_mpi"

# Run Python first: it copies benchmark genomes, then finance genomes.
# Run from uti/ so "python copy_genome.py" finds the script.
python copy_genome.py
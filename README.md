<div align="center">

<img src="docs/logos/cahsi.png" alt="CAHSI" height="120"/>

# EXAMM on S&P — Financial Time Series Neuro-Evolution

**Evolving recurrent neural architectures for next-day stock return prediction**

<sub>Purdue Anvil · SLURM · MPI · EXAMM-Extended</sub>

</div>

---

## Overview

This repository drives a large-scale neuro-evolution experiment on Purdue's
**Anvil HPC cluster**. For each of **50 S&P 500 stocks**, we run **25 folds** of
[EXAMM](https://github.com/travisdesell/exact) (Evolutionary eXploration of
Augmenting Memory Models) to evolve RNN architectures that predict the next-day
return (`RET`) from six daily market features.

| Item | Value |
|---|---|
| Stocks | 50 (S&P 500 constituents) |
| Folds per stock | 25 |
| Jobs total | 1,250 |
| Max genomes per run | 10,000 |
| MPI ranks per job | 8 |
| Walltime ceiling | 00:30:00 |
| Split | 70 / 15 / 15 train / val / test |
| Node types evolved | `simple`, `UGRNN`, `MGU`, `GRU`, `delta`, `LSTM` |

**Input features:** `VOL_CHANGE`, `BA_SPREAD`, `ILLIQUIDITY`, `sprtrn`,
`TURNOVER`, `RET`
**Target:** next-day `RET`

---

## Pipeline

```
 ┌──────────────────┐
 │ generate_bash.py │   templates 1,250 per-fold SLURM scripts
 └────────┬─────────┘
          │
          ▼
 ┌──────────────────┐
 │    submit.sh     │   throttled sbatch loop (caps at 400 queued)
 └────────┬─────────┘
          │
          ▼
 ┌──────────────────┐
 │   Anvil + MPI    │   8 ranks × island-based evolution (10 islands × 10 genomes)
 └────────┬─────────┘
          │
          ▼
 ┌──────────────────┐
 │   scratch/...    │   fitness_log.csv + rnn_genome_*.bin per fold
 └────────┬─────────┘
          │
          ▼
 ┌──────────────────┐
 │ save_needed_…sh  │   harvests best genome + fitness log per fold
 └──────────────────┘
```

---

## Repository Layout

```
examm_scripts/
├── generate_bash.py           # Templates per-(stock, fold) SLURM scripts
├── submit.sh                  # Throttled batch submitter (49 stocks × 25 folds)
├── 250/                       # Generated .sh files, one per stock+fold
├── list_best_genomes.sh       # Finds lowest-fitness genome in each fold
├── collect_best_genomes.sh    # Copies best genomes to a flat directory
├── save_needed_outputs.sh     # Final harvest: best genome + fitness log per run
├── 2023_full_AKAM.sh          # Single-stock sequential script (legacy)
└── docs/logos/                # Project + acknowledgment logos
```

---

## Running the Full Batch

```bash
# 1. Regenerate all 1,250 per-fold SLURM scripts
python3 generate_bash.py

# 2. Launch inside tmux so SSH disconnects don't kill the submitter
tmux new -s batch
bash submit.sh
# detach: Ctrl+B then D

# 3. Monitor
squeue -u $USER | wc -l
sacct -u $USER -S $(date -Idate) --format=State -X | sort | uniq -c
```

`submit.sh` self-throttles at **400 queued jobs** and sleeps 60s whenever the
cap is reached, so it is safe to fire-and-forget.

---

## Single-Run Sanity Check

For a canary before the full batch:

```bash
sbatch 250/250_NDSN_2.sh
sbatch 250/250_NDSN_13.sh
sacct -j <jobid> --format=JobID,JobName,Elapsed,State,ExitCode,Timelimit
```

A healthy fold completes in **~5 minutes** and writes a `fitness_log.csv` of
**~9,900 lines** (one row per genome).

---

## Results Harvest

After the batch drains, output lives on scratch, which is **periodically purged**.
Move it to persistent storage immediately:

```bash
mkdir -p ~/examm_harvest
cp -r /anvil/scratch/$USER/results/701515_split_250/<STOCK> ~/examm_harvest/
```

Then download locally with `rsync`:

```bash
rsync -av --progress anvil:~/examm_harvest/ ./local_results/
```

---

## Known Quirks

- **EXAMM segfaults non-deterministically.** Roughly 5–10 % of folds crash
  during `RNN_Genome::add_edge()` in the mutation step. Failed folds are
  identified by short `fitness_log.csv` files and simply re-submitted — they
  almost always succeed on retry thanks to different random seeding.
- **Walltime is a ceiling, not a reservation.** Typical folds finish in
  3–10 minutes. The 30-minute ceiling acts as a circuit breaker that kills
  pathological runs before they burn SUs.
- **`save_needed_outputs.sh` prefers `global_best_genome_*.bin`** when present,
  otherwise falls back to the minimum-fitness `rnn_genome_<id>.bin`.

---

## Acknowledgments

<div align="center">

<img src="docs/logos/cahsi.png" alt="CAHSI" height="80"/>
&nbsp;&nbsp;&nbsp;&nbsp;
<img src="docs/logos/anvil.png" alt="Purdue Anvil" height="80"/>
&nbsp;&nbsp;&nbsp;&nbsp;
<img src="docs/logos/access.png" alt="ACCESS CI" height="80"/>

</div>

This work is supported by the **Computing Alliance of Hispanic-Serving
Institutions (CAHSI)**, runs on **Purdue University's Anvil** cluster, and is
resourced through an **ACCESS** allocation. EXAMM was originally developed at
**Rochester Institute of Technology**.

---

## License

Pending — to be decided in consultation with collaborators.

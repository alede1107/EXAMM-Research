#!/bin/bash

script_path="/home/x-aperdomo/examm_scripts"
file_type="250"

for DATASET in 'NDSN' 'HOLX' 'ATO' 'KIM' 'NVR' 'DPZ' 'JBHT' 'DECK' 'FRT' 'KMX' 'EXR' 'LNT' 'CINF' 'ED' 'REG' 'CPB' 'LH' 'TRMB' 'DVA' 'PKG' 'CAG' 'NTRS' 'KMB' 'TRV' 'RHI' 'UHS' 'EMN' 'PODD' 'TECH' 'EXPD' 'WRB' 'EIX' 'STLD' 'BXP' 'CHRW' 'IVZ' 'HSIC' 'TFX' 'AKAM' 'JKHY' 'HBAN' 'ESS' 'ETR' 'FFIV' 'CPT' 'IEX' 'IRM' 'COO' 'MHK' 'FDS'
do
    echo "Submitting ${script_path}/${file_type}/${file_type}_${DATASET}.sh"
    sbatch ${script_path}/${file_type}/${file_type}_${DATASET}.sh
done

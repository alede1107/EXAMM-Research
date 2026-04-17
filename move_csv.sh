#!/bin/bash -l

# Please copy this file to your home directory and modify it
# to suit your needs.
# 
# If you need any help, please email rc-help@rit.edu
#

# Name of the job - You'll probably want to customize this.
#SBATCH -J move

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


# EXAMM_PATH="/home/zl7069/git/debug/exact"
# DATASET="ETTh1"
# RESULT_TYPE="AAAI_EXAMM_round8"
# # /home/zl7069/git/debug/exact/AAAI_EXAMM_round3/multivariate/electricity/offset_1/sequence_25/epoch_1/mutation_1/frequence_150/0

# for DATA_TYPE in  multivariate
# do
#     for DATASET in ETTh1 ETTh2  ETTm1 ETTm2  exchange_rate cyclone turbine weather illness
#     do 

#         for offset in 1 6 12
#         do
#             for sequence_length in 25 
#             do 
#                 for epoch in 10
#                 do
#                     for mutation in 1 3 5
#                     do
#                         for frequency in 150 300
#                         do
#                             for repeat in {0..9}
#                             do 
#                                 result_path=$EXAMM_PATH/$RESULT_TYPE/$DATA_TYPE/$DATASET/offset_${offset}/sequence_${sequence_length}/epoch_${epoch}/mutation_${mutation}/frequence_${frequency}/$repeat
#                                 if [ -d "$result_path" ]; then
#                                 # Directory exists
#                                     target_path=/home/zl7069/git/cluster_results/$RESULT_TYPE/$DATA_TYPE/$DATASET/offset_${offset}/sequence_${sequence_length}/epoch_${epoch}/mutation_${mutation}/frequence_${frequency}/$repeat
#                                     mkdir -p $target_path
#                                     cp $result_path/*.csv $target_path
#                                     GENOME=$result_path/global_best_genome_*.bin
#                                     cp $GENOME $target_path/ 
#                                 fi

#                             done
#                         done
#                     done
#                 done
#             done
#         done
#     done
# done

# EXAMM_PATH="/home/zl7069/git/debug/exact"
# DATA_PATH="/home/zl7069/datasets/EXAMM-Data"
# RESULT_TYPE="AAAI_EXAMM_scalabiliy_2"
# RESULT_PATH=$EXAMM_PATH/${RESULT_TYPE}/multivariate
# DATASET="ETTh1"

# INPUT_PARAMETERS="HUFL HULL MUFL MULL LUFL LULL OT"
# OUTPUT_PARAMETERS="OT"
#     for core in 2 4 8 16 32 64
#     do
#         for repeat in {0..9}
#         do 
#             result_path=$RESULT_PATH/$DATASET/core_${core}/$repeat

            # result_path=$EXAMM_PATH/$RESULT_TYPE/$DATA_TYPE/$DATASET/offset_${offset}/sequence_${sequence_length}/epoch_${epoch}/mutation_${mutation}/frequence_${frequency}/$repeat
            # if [ -d "$result_path" ]; then
            # # Directory exists
            #     target_path=/home/zl7069/git/cluster_results/$RESULT_TYPE/multivariate/$DATASET/core_${core}/$repeat
            #     mkdir -p $target_path
            #     cp $result_path/*.csv $target_path
            #     GENOME=$result_path/global_best_genome_*.bin
            #     cp $GENOME $target_path/ 
#             fi
#         done
#     done



# EXAMM_PATH="/home/zl7069/git/debug/exact"
# DATA_PATH="/home/zl7069/datasets/EXAMM-Data"
# RESULT_TYPE="AAAI_EXAMM_parameter_3"
# RESULT_PATH=$EXAMM_PATH/${RESULT_TYPE}/multivariate
# DATASET="ETTh1"

# INPUT_PARAMETERS="HUFL HULL MUFL MULL LUFL LULL OT"
# OUTPUT_PARAMETERS="OT"

# for offset in 6
# do
#     for sequence_length in 25
#     do 
#         for epoch in 5
#         do
#             for mutation in 1
#             do
#                 for frequency in 500
#                 do
#                     for island in 5 10 15 20 30 40
#                     do
#                         for capacity in 5 10 15 20 30 40
#                         do
                    
#                             for repeat in {0..9}
#                             do 
#                                 result_path=$RESULT_PATH/$DATASET/offset_${offset}/sequence_${sequence_length}/epoch_${epoch}/mutation_${mutation}/frequence_${frequency}/island_${island}/capacity_${capacity}/$repeat
#                                 # Directory exists
#                                 if [ -d "$result_path" ]; then
#                                     target_path=/home/zl7069/git/cluster_results/$RESULT_TYPE/multivariate/$DATASET/offset_${offset}/sequence_${sequence_length}/epoch_${epoch}/mutation_${mutation}/frequence_${frequency}/island_${island}/capacity_${capacity}/$repeat
#                                     mkdir -p $target_path
#                                     cp $result_path/*.csv $target_path
#                                     GENOME=$result_path/global_best_genome_*.bin
#                                     cp $GENOME $target_path/ 
#                                 fi
#                             done
#                         done
#                     done
#                 done
#             done
#         done
#     done
# done



# MAX_GENOME=10000
# EXAMM="/home/zl7069/git/debug/exact"
# for result_dir in "701515_split_2023_full"
# do
#     # for DATASET in 'AAPL' 'AXP' 'BA' 'CAT' 'CSCO' 'CVX' 'DOW' 'DIS' 'WBA' 'GS' 'HD' 'IBM' 'INTC' 'JNJ' 'JPM' 'KO' 'MCD' 'MMM' 'MRK' 'MSFT' 'NKE' 'HON' 'PG' 'TRV' 'UNH' 'AMGN' 'VZ' 'V' 'WMT' 'CRM'
#     for DATASET in 'NDSN' 'HOLX' 'ATO' 'KIM' 'NVR' 'DPZ' 'JBHT' 'DECK' 'FRT' 'KMX' 'EXR' 'LNT' 'CINF' 'ED' 'REG' 'CPB' 'LH' 'TRMB' 'DVA' 'PKG' 'CAG' 'NTRS' 'KMB' 'TRV' 'RHI' 'UHS' 'EMN' 'PODD' 'TECH' 'EXPD' 'WRB' 'EIX' 'STLD' 'BXP' 'CHRW' 'IVZ' 'HSIC' 'TFX' 'AKAM' 'JKHY' 'HBAN' 'ESS' 'ETR' 'FFIV' 'CPT' 'IEX' 'IRM' 'COO' 'MHK' 'FDS'
#     # for DATASET in 'A' 'AAL' 'AAPL' 'ABBV' 'ABNB' 'ABT' 'ACGL' 'ACN' 'ADBE' 'ADI' 'ADM' 'ADP' 'ADSK' 'AEE' 'AEP' 'AES' 'AFL' 'AIG' 'AIZ' 'AJG' 'AKAM' 'ALB' 'ALGN' 'ALL' 'ALLE' 'AMAT' 'AMCR' 'AMD' 'AME' 'AMGN' 'AMP' 'AMT' 'AMZN' 'ANET' 'ANSS' 'AON' 'AOS' 'APA' 'APD' 'APH' 'APTV' 'ARE' 'ATO' 'AVB' 'AVGO' 'AVY' 'AWK' 'AXON' 'AXP' 'AZO' 'BA' 'BAC' 'BALL' 'BAX' 'BBWI' 'BBY' 'BDX' 'BEN' 'BF' 'BG' 'BIIB' 'BIO' 'BK' 'BKNG' 'BKR' 'BLDR' 'BLK' 'BMY' 'BR' 'BRK' 'BRO' 'BSX' 'BWA' 'BX' 'BXP' 'C' 'CAG' 'CAH' 'CARR' 'CAT' 'CB' 'CBOE' 'CBRE' 'CCI' 'CCL' 'CDAY' 'CDNS' 'CDW' 'CE' 'CF' 'CFG' 'CHD' 'CHRW' 'CHTR' 'CI' 'CINF' 'CL' 'CLX' 'CMA' 'CMCSA' 'CME' 'CMG' 'CMI' 'CMS' 'CNC' 'CNP' 'COF' 'COO' 'COP' 'COR' 'COST' 'CPB' 'CPRT' 'CPT' 'CRL' 'CRM' 'CSCO' 'CSGP' 'CSX' 'CTAS' 'CTLT' 'CTRA' 'CTSH' 'CTVA' 'CVS' 'CVX' 'CZR' 'D' 'DAL' 'DD' 'DE' 'DECK' 'DFS' 'DG' 'DGX' 'DHI' 'DHR' 'DIS' 'DLR' 'DLTR' 'DOC' 'DOV' 'DOW' 'DPZ' 'DRI' 'DTE' 'DUK' 'DVA' 'DVN' 'DXCM' 'EA' 'EBAY' 'ECL' 'ED' 'EFX' 'EG' 'EIX' 'EL' 'ELV' 'EMN' 'EMR' 'ENPH' 'EOG' 'EPAM' 'EQIX' 'EQR' 'EQT' 'ES' 'ESS' 'ETN' 'ETR' 'ETSY' 'EVRG' 'EW' 'EXC' 'EXPD' 'EXPE' 'EXR' 'F' 'FANG' 'FAST' 'FCX' 'FDS' 'FDX' 'FE' 'FFIV' 'FI' 'FICO' 'FIS' 'FITB' 'FLT' 'FMC' 'FOX' 'FOXA' 'FRT' 'FSLR' 'FTNT' 'FTV' 'GD' 'GE' 'GEN' 'GILD' 'GIS' 'GL' 'GLW' 'GM' 'GNRC' 'GOOG' 'GOOGL' 'GPC' 'GPN' 'GRMN' 'GS' 'GWW' 'HAL' 'HAS' 'HBAN' 'HCA' 'HCN' 'HD' 'HES' 'HIG' 'HII' 'HLT' 'HOLX' 'HON' 'HPE' 'HPQ' 'HRL' 'HSIC' 'HST' 'HSY' 'HUBB' 'HUM' 'HWM' 'IBM' 'ICE' 'IDXX' 'IEX' 'IFF' 'ILMN' 'INCY' 'INTC' 'INTU' 'INVH' 'IP' 'IPG' 'IQV' 'IR' 'IRM' 'ISRG' 'IT' 'ITW' 'IVZ' 'J' 'JBHT' 'JBL' 'JCI' 'JKHY' 'JNJ' 'JNPR' 'JPM' 'K' 'KDP' 'KEY' 'KEYS' 'KHC' 'KIM' 'KLAC' 'KMB' 'KMI' 'KMX' 'KO' 'KR' 'L' 'LDOS' 'LEN' 'LH' 'LHX' 'LIN' 'LKQ' 'LLY' 'LMT' 'LNT' 'LOW' 'LRCX' 'LULU' 'LUV' 'LVS' 'LW' 'LYB' 'LYV' 'MA' 'MAA' 'MAR' 'MAS' 'MCD' 'MCHP' 'MCK' 'MCO' 'MDLZ' 'MDT' 'MET' 'META' 'MGM' 'MHK' 'MKC' 'MKTX' 'MLM' 'MMC' 'MMM' 'MNST' 'MO' 'MOH' 'MOS' 'MPC' 'MPWR' 'MRK' 'MRNA' 'MRO' 'MS' 'MSCI' 'MSFT' 'MSI' 'MTB' 'MTCH' 'MTD' 'MU' 'NCLH' 'NDAQ' 'NDSN' 'NEE' 'NEM' 'NFLX' 'NI' 'NKE' 'NOC' 'NOW' 'NRG' 'NSC' 'NTAP' 'NTRS' 'NUE' 'NVDA' 'NVR' 'NWS' 'NWSA' 'NXPI' 'O' 'ODFL' 'OKE' 'OMC' 'ON' 'ORCL' 'ORLY' 'OTIS' 'OXY' 'PANW' 'PARA' 'PAYC' 'PAYX' 'PCAR' 'PCG' 'PEG' 'PEP' 'PFE' 'PFG' 'PG' 'PGR' 'PH' 'PHM' 'PKG' 'PLD' 'PM' 'PNC' 'PNR' 'PNW' 'PODD' 'POOL' 'PPG' 'PPL' 'PRU' 'PSA' 'PSX' 'PTC' 'PWR' 'PXD' 'PYPL' 'QCOM' 'QRVO' 'RCL' 'REG' 'REGN' 'RF' 'RHI' 'RJF' 'RL' 'RMD' 'ROK' 'ROL' 'ROP' 'ROST' 'RSG' 'RTX' 'RVTY' 'SBAC' 'SBUX' 'SCHW' 'SHW' 'SJM' 'SLB' 'SMCI' 'SNA' 'SNPS' 'SO' 'SPG' 'SPGI' 'SRE' 'STE' 'STLD' 'STT' 'STX' 'STZ' 'SWK' 'SWKS' 'SYF' 'SYK' 'SYY' 'T' 'TAP' 'TDG' 'TDY' 'TECH' 'TEL' 'TER' 'TFC' 'TFX' 'TGT' 'TJX' 'TMO' 'TMUS' 'TPR' 'TRGP' 'TRMB' 'TROW' 'TRV' 'TSCO' 'TSLA' 'TSN' 'TT' 'TTWO' 'TXN' 'TXT' 'TYL' 'UAL' 'UBER' 'UDR' 'UHS' 'ULTA' 'UNH' 'UNP' 'UPS' 'URI' 'USB' 'V' 'VICI' 'VLO' 'VMC' 'VRSK' 'VRSN' 'VRTX' 'VTR' 'VTRS' 'VZ' 'WAB' 'WAT' 'WBA' 'WDC' 'WEC' 'WFC' 'WM' 'WMB' 'WMT' 'WRB' 'WRK' 'WST' 'WTW' 'WY' 'WYNN' 'XEL' 'XOM' 'XYL' 'YUM' 'ZBH' 'ZBRA' 'ZTS'

#     do
#         for method in "lr_0.001/max_genome_10000/island_10"
#         do
#     #         for NUM_ISLANDS_KILL in 10
#     #         do
#                 for folder in {0..24}
#                 do
#                     exp_name="/home/zl7069/git/cluster_results/$result_dir/$DATASET/$method/$folder"
#                     mkdir -p $exp_name
#                     file="$EXAMM/$result_dir/$DATASET/$method/$folder/fitness_log.csv"
#                     target="$exp_name/fitness_log.csv"
#                     cp $file $target

#                 done
#     #         done
#         done
#     done
# done

# Copy fitness logs from EXAMM-Extended benchmark to cluster_results (same logic as below)
EXAMM_BENCHMARK="/home/zl7069/git/EXAMM-Extended/benchmark"
RESULT_TYPE="benchmark_new"
for DATASET in weather
do
    for folder in {0..9}
    do
        result_path="$EXAMM_BENCHMARK/$DATASET/5000/$folder"
        if [ -f "$result_path/fitness_log.csv" ]; then
            target_path="/home/zl7069/git/cluster_results/$RESULT_TYPE/$DATASET/$folder"
            mkdir -p "$target_path"
            cp "$result_path/fitness_log.csv" "$target_path/"
        fi
    done
done

# MAX_GENOME=10000
# EXAMM="/home/zl7069/git/debug/exact"
# for result_dir in "701515_split_250"
# do
#     # for DATASET in 'AAPL' 'AXP' 'BA' 'CAT' 'CSCO' 'CVX' 'DOW' 'DIS' 'WBA' 'GS' 'HD' 'IBM' 'INTC' 'JNJ' 'JPM' 'KO' 'MCD' 'MMM' 'MRK' 'MSFT' 'NKE' 'HON' 'PG' 'TRV' 'UNH' 'AMGN' 'VZ' 'V' 'WMT' 'CRM'
#     for DATASET in 'NDSN' 'HOLX' 'ATO' 'KIM' 'NVR' 'DPZ' 'JBHT' 'DECK' 'FRT' 'KMX' 'EXR' 'LNT' 'CINF' 'ED' 'REG' 'CPB' 'LH' 'TRMB' 'DVA' 'PKG' 'CAG' 'NTRS' 'KMB' 'TRV' 'RHI' 'UHS' 'EMN' 'PODD' 'TECH' 'EXPD' 'WRB' 'EIX' 'STLD' 'BXP' 'CHRW' 'IVZ' 'HSIC' 'TFX' 'AKAM' 'JKHY' 'HBAN' 'ESS' 'ETR' 'FFIV' 'CPT' 'IEX' 'IRM' 'COO' 'MHK' 'FDS'
#     # for DATASET in 'A' 'AAL' 'AAPL' 'ABBV' 'ABNB' 'ABT' 'ACGL' 'ACN' 'ADBE' 'ADI' 'ADM' 'ADP' 'ADSK' 'AEE' 'AEP' 'AES' 'AFL' 'AIG' 'AIZ' 'AJG' 'AKAM' 'ALB' 'ALGN' 'ALL' 'ALLE' 'AMAT' 'AMCR' 'AMD' 'AME' 'AMGN' 'AMP' 'AMT' 'AMZN' 'ANET' 'ANSS' 'AON' 'AOS' 'APA' 'APD' 'APH' 'APTV' 'ARE' 'ATO' 'AVB' 'AVGO' 'AVY' 'AWK' 'AXON' 'AXP' 'AZO' 'BA' 'BAC' 'BALL' 'BAX' 'BBWI' 'BBY' 'BDX' 'BEN' 'BF' 'BG' 'BIIB' 'BIO' 'BK' 'BKNG' 'BKR' 'BLDR' 'BLK' 'BMY' 'BR' 'BRK' 'BRO' 'BSX' 'BWA' 'BX' 'BXP' 'C' 'CAG' 'CAH' 'CARR' 'CAT' 'CB' 'CBOE' 'CBRE' 'CCI' 'CCL' 'CDAY' 'CDNS' 'CDW' 'CE' 'CF' 'CFG' 'CHD' 'CHRW' 'CHTR' 'CI' 'CINF' 'CL' 'CLX' 'CMA' 'CMCSA' 'CME' 'CMG' 'CMI' 'CMS' 'CNC' 'CNP' 'COF' 'COO' 'COP' 'COR' 'COST' 'CPB' 'CPRT' 'CPT' 'CRL' 'CRM' 'CSCO' 'CSGP' 'CSX' 'CTAS' 'CTLT' 'CTRA' 'CTSH' 'CTVA' 'CVS' 'CVX' 'CZR' 'D' 'DAL' 'DD' 'DE' 'DECK' 'DFS' 'DG' 'DGX' 'DHI' 'DHR' 'DIS' 'DLR' 'DLTR' 'DOC' 'DOV' 'DOW' 'DPZ' 'DRI' 'DTE' 'DUK' 'DVA' 'DVN' 'DXCM' 'EA' 'EBAY' 'ECL' 'ED' 'EFX' 'EG' 'EIX' 'EL' 'ELV' 'EMN' 'EMR' 'ENPH' 'EOG' 'EPAM' 'EQIX' 'EQR' 'EQT' 'ES' 'ESS' 'ETN' 'ETR' 'ETSY' 'EVRG' 'EW' 'EXC' 'EXPD' 'EXPE' 'EXR' 'F' 'FANG' 'FAST' 'FCX' 'FDS' 'FDX' 'FE' 'FFIV' 'FI' 'FICO' 'FIS' 'FITB' 'FLT' 'FMC' 'FOX' 'FOXA' 'FRT' 'FSLR' 'FTNT' 'FTV' 'GD' 'GE' 'GEN' 'GILD' 'GIS' 'GL' 'GLW' 'GM' 'GNRC' 'GOOG' 'GOOGL' 'GPC' 'GPN' 'GRMN' 'GS' 'GWW' 'HAL' 'HAS' 'HBAN' 'HCA' 'HCN' 'HD' 'HES' 'HIG' 'HII' 'HLT' 'HOLX' 'HON' 'HPE' 'HPQ' 'HRL' 'HSIC' 'HST' 'HSY' 'HUBB' 'HUM' 'HWM' 'IBM' 'ICE' 'IDXX' 'IEX' 'IFF' 'ILMN' 'INCY' 'INTC' 'INTU' 'INVH' 'IP' 'IPG' 'IQV' 'IR' 'IRM' 'ISRG' 'IT' 'ITW' 'IVZ' 'J' 'JBHT' 'JBL' 'JCI' 'JKHY' 'JNJ' 'JNPR' 'JPM' 'K' 'KDP' 'KEY' 'KEYS' 'KHC' 'KIM' 'KLAC' 'KMB' 'KMI' 'KMX' 'KO' 'KR' 'L' 'LDOS' 'LEN' 'LH' 'LHX' 'LIN' 'LKQ' 'LLY' 'LMT' 'LNT' 'LOW' 'LRCX' 'LULU' 'LUV' 'LVS' 'LW' 'LYB' 'LYV' 'MA' 'MAA' 'MAR' 'MAS' 'MCD' 'MCHP' 'MCK' 'MCO' 'MDLZ' 'MDT' 'MET' 'META' 'MGM' 'MHK' 'MKC' 'MKTX' 'MLM' 'MMC' 'MMM' 'MNST' 'MO' 'MOH' 'MOS' 'MPC' 'MPWR' 'MRK' 'MRNA' 'MRO' 'MS' 'MSCI' 'MSFT' 'MSI' 'MTB' 'MTCH' 'MTD' 'MU' 'NCLH' 'NDAQ' 'NDSN' 'NEE' 'NEM' 'NFLX' 'NI' 'NKE' 'NOC' 'NOW' 'NRG' 'NSC' 'NTAP' 'NTRS' 'NUE' 'NVDA' 'NVR' 'NWS' 'NWSA' 'NXPI' 'O' 'ODFL' 'OKE' 'OMC' 'ON' 'ORCL' 'ORLY' 'OTIS' 'OXY' 'PANW' 'PARA' 'PAYC' 'PAYX' 'PCAR' 'PCG' 'PEG' 'PEP' 'PFE' 'PFG' 'PG' 'PGR' 'PH' 'PHM' 'PKG' 'PLD' 'PM' 'PNC' 'PNR' 'PNW' 'PODD' 'POOL' 'PPG' 'PPL' 'PRU' 'PSA' 'PSX' 'PTC' 'PWR' 'PXD' 'PYPL' 'QCOM' 'QRVO' 'RCL' 'REG' 'REGN' 'RF' 'RHI' 'RJF' 'RL' 'RMD' 'ROK' 'ROL' 'ROP' 'ROST' 'RSG' 'RTX' 'RVTY' 'SBAC' 'SBUX' 'SCHW' 'SHW' 'SJM' 'SLB' 'SMCI' 'SNA' 'SNPS' 'SO' 'SPG' 'SPGI' 'SRE' 'STE' 'STLD' 'STT' 'STX' 'STZ' 'SWK' 'SWKS' 'SYF' 'SYK' 'SYY' 'T' 'TAP' 'TDG' 'TDY' 'TECH' 'TEL' 'TER' 'TFC' 'TFX' 'TGT' 'TJX' 'TMO' 'TMUS' 'TPR' 'TRGP' 'TRMB' 'TROW' 'TRV' 'TSCO' 'TSLA' 'TSN' 'TT' 'TTWO' 'TXN' 'TXT' 'TYL' 'UAL' 'UBER' 'UDR' 'UHS' 'ULTA' 'UNH' 'UNP' 'UPS' 'URI' 'USB' 'V' 'VICI' 'VLO' 'VMC' 'VRSK' 'VRSN' 'VRTX' 'VTR' 'VTRS' 'VZ' 'WAB' 'WAT' 'WBA' 'WDC' 'WEC' 'WFC' 'WM' 'WMB' 'WMT' 'WRB' 'WRK' 'WST' 'WTW' 'WY' 'WYNN' 'XEL' 'XOM' 'XYL' 'YUM' 'ZBH' 'ZBRA' 'ZTS'

#     do
#         for method in "lr_0.001/max_genome_10000/island_10"
#         do
#     #         for NUM_ISLANDS_KILL in 10
#     #         do
#                 for folder in {0..24}
#                 do
#                     exp_name="/home/zl7069/git/cluster_results/$result_dir/$DATASET/$method/$folder"
#                     mkdir -p $exp_name
#                     file="$EXAMM/$result_dir/$DATASET/$method/$folder/fitness_log.csv"
#                     target="$exp_name/fitness_log.csv"
#                     cp $file $target

#                 done
#     #         done
#         done
#     done
# done
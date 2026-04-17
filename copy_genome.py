import sys
import os
import shutil
 

# Copy genomes from EXAMM-Extended benchmark to cluster_results (same logic as below)
examm_benchmark = "/home/zl7069/git/EXAMM-Extended/benchmark"
result_type = "benchmark_new"
cluster_results_base = "/home/zl7069/git/cluster_results"
for DATASET in ["weather"]:
    for folder in range(10):
        genome_dir = os.path.join(examm_benchmark, DATASET, "5000", str(folder))
        exp_name = os.path.join(cluster_results_base, result_type, DATASET, str(folder))
        if not os.path.isdir(genome_dir):
            continue
        os.makedirs(exp_name, exist_ok=True)
        files = os.listdir(genome_dir)
        max_num = -1
        best_genome_file = None
        for f in files:
            path = os.path.join(genome_dir, f)
            if not os.path.isfile(path):
                continue
            if f.startswith("global_best"):
                shutil.copy2(path, os.path.join(exp_name, f))
            elif f.startswith("genome_") and "_worker_" in f:
                parts = f.split("_")
                if len(parts) >= 2:
                    try:
                        num = int(parts[1])
                        if num > max_num:
                            max_num = num
                            best_genome_file = f
                    except ValueError:
                        pass
            elif "_genome_" in f and f.endswith(".gv"):
                try:
                    num = int(f.split("_genome_")[1].split(".gv")[0])
                    if num > max_num:
                        max_num = num
                        best_genome_file = f
                except (ValueError, IndexError):
                    pass
        if best_genome_file:
            shutil.copy2(os.path.join(genome_dir, best_genome_file), os.path.join(exp_name, best_genome_file))

examm="/home/zl7069/git/debug/exact/"

for result_folder in ["701515_split_2023_full/"]:
    # for DATASET in ['AAPL', 'AXP', 'BA', 'CAT', 'CSCO', 'CVX', 'DOW', 'DIS', 'WBA', 'GS', 'HD', 'IBM', 'INTC', 'JNJ', 'JPM', 'KO', 'MCD', 'MMM', 'MRK', 'MSFT', 'NKE', 'HON', 'PG', 'TRV', 'UNH', 'AMGN', 'VZ', 'V', 'WMT', 'CRM']:
    for DATASET in ['NDSN', 'HOLX', 'ATO', 'KIM', 'NVR', 'DPZ', 'JBHT', 'DECK', 'FRT', 'KMX', 'EXR', 'LNT', 'CINF', 'ED', 'REG', 'CPB', 'LH', 'TRMB', 'DVA', 'PKG', 'CAG', 'NTRS', 'KMB', 'TRV', 'RHI', 'UHS', 'EMN', 'PODD', 'TECH', 'EXPD', 'WRB', 'EIX', 'STLD', 'BXP', 'CHRW', 'IVZ', 'HSIC', 'TFX', 'AKAM', 'JKHY', 'HBAN', 'ESS', 'ETR', 'FFIV', 'CPT', 'IEX', 'IRM', 'COO', 'MHK', 'FDS']:
    # for DATASET in ['A', 'AAL', 'AAPL', 'ABBV', 'ABNB', 'ABT', 'ACGL', 'ACN', 'ADBE', 'ADI', 'ADM', 'ADP', 'ADSK', 'AEE', 'AEP', 'AES', 'AFL', 'AIG', 'AIZ', 'AJG', 'AKAM', 'ALB', 'ALGN', 'ALL', 'ALLE', 'AMAT', 'AMCR', 'AMD', 'AME', 'AMGN', 'AMP', 'AMT', 'AMZN', 'ANET', 'ANSS', 'AON', 'AOS', 'APA', 'APD', 'APH', 'APTV', 'ARE', 'ATO', 'AVB', 'AVGO', 'AVY', 'AWK', 'AXON', 'AXP', 'AZO', 'BA', 'BAC', 'BALL', 'BAX', 'BBWI', 'BBY', 'BDX', 'BEN', 'BF', 'BG', 'BIIB', 'BIO', 'BK', 'BKNG', 'BKR', 'BLDR', 'BLK', 'BMY', 'BR', 'BRK', 'BRO', 'BSX', 'BWA', 'BX', 'BXP', 'C', 'CAG', 'CAH', 'CARR', 'CAT', 'CB', 'CBOE', 'CBRE', 'CCI', 'CCL', 'CDAY', 'CDNS', 'CDW', 'CE', 'CF', 'CFG', 'CHD', 'CHRW', 'CHTR', 'CI', 'CINF', 'CL', 'CLX', 'CMA', 'CMCSA', 'CME', 'CMG', 'CMI', 'CMS', 'CNC', 'CNP', 'COF', 'COO', 'COP', 'COR', 'COST', 'CPB', 'CPRT', 'CPT', 'CRL', 'CRM', 'CSCO', 'CSGP', 'CSX', 'CTAS', 'CTLT', 'CTRA', 'CTSH', 'CTVA', 'CVS', 'CVX', 'CZR', 'D', 'DAL', 'DD', 'DE', 'DECK', 'DFS', 'DG', 'DGX', 'DHI', 'DHR', 'DIS', 'DLR', 'DLTR', 'DOC', 'DOV', 'DOW', 'DPZ', 'DRI', 'DTE', 'DUK', 'DVA', 'DVN', 'DXCM', 'EA', 'EBAY', 'ECL', 'ED', 'EFX', 'EG', 'EIX', 'EL', 'ELV', 'EMN', 'EMR', 'ENPH', 'EOG', 'EPAM', 'EQIX', 'EQR', 'EQT', 'ES', 'ESS', 'ETN', 'ETR', 'ETSY', 'EVRG', 'EW', 'EXC', 'EXPD', 'EXPE', 'EXR', 'F', 'FANG', 'FAST', 'FCX', 'FDS', 'FDX', 'FE', 'FFIV', 'FI', 'FICO', 'FIS', 'FITB', 'FLT', 'FMC', 'FOX', 'FOXA', 'FRT', 'FSLR', 'FTNT', 'FTV', 'GD', 'GE', 'GEN', 'GILD', 'GIS', 'GL', 'GLW', 'GM', 'GNRC', 'GOOG', 'GOOGL', 'GPC', 'GPN', 'GRMN', 'GS', 'GWW', 'HAL', 'HAS', 'HBAN', 'HCA', 'HCN', 'HD', 'HES', 'HIG', 'HII', 'HLT', 'HOLX', 'HON', 'HPE', 'HPQ', 'HRL', 'HSIC', 'HST', 'HSY', 'HUBB', 'HUM', 'HWM', 'IBM', 'ICE', 'IDXX', 'IEX', 'IFF', 'ILMN', 'INCY', 'INTC', 'INTU', 'INVH', 'IP', 'IPG', 'IQV', 'IR', 'IRM', 'ISRG', 'IT', 'ITW', 'IVZ', 'J', 'JBHT', 'JBL', 'JCI', 'JKHY', 'JNJ', 'JNPR', 'JPM', 'K', 'KDP', 'KEY', 'KEYS', 'KHC', 'KIM', 'KLAC', 'KMB', 'KMI', 'KMX', 'KO', 'KR', 'L', 'LDOS', 'LEN', 'LH', 'LHX', 'LIN', 'LKQ', 'LLY', 'LMT', 'LNT', 'LOW', 'LRCX', 'LULU', 'LUV', 'LVS', 'LW', 'LYB', 'LYV', 'MA', 'MAA', 'MAR', 'MAS', 'MCD', 'MCHP', 'MCK', 'MCO', 'MDLZ', 'MDT', 'MET', 'META', 'MGM', 'MHK', 'MKC', 'MKTX', 'MLM', 'MMC', 'MMM', 'MNST', 'MO', 'MOH', 'MOS', 'MPC', 'MPWR', 'MRK', 'MRNA', 'MRO', 'MS', 'MSCI', 'MSFT', 'MSI', 'MTB', 'MTCH', 'MTD', 'MU', 'NCLH', 'NDAQ', 'NDSN', 'NEE', 'NEM', 'NFLX', 'NI', 'NKE', 'NOC', 'NOW', 'NRG', 'NSC', 'NTAP', 'NTRS', 'NUE', 'NVDA', 'NVR', 'NWS', 'NWSA', 'NXPI', 'O', 'ODFL', 'OKE', 'OMC', 'ON', 'ORCL', 'ORLY', 'OTIS', 'OXY', 'PANW', 'PARA', 'PAYC', 'PAYX', 'PCAR', 'PCG', 'PEG', 'PEP', 'PFE', 'PFG', 'PG', 'PGR', 'PH', 'PHM', 'PKG', 'PLD', 'PM', 'PNC', 'PNR', 'PNW', 'PODD', 'POOL', 'PPG', 'PPL', 'PRU', 'PSA', 'PSX', 'PTC', 'PWR', 'PXD', 'PYPL', 'QCOM', 'QRVO', 'RCL', 'REG', 'REGN', 'RF', 'RHI', 'RJF', 'RL', 'RMD', 'ROK', 'ROL', 'ROP', 'ROST', 'RSG', 'RTX', 'RVTY', 'SBAC', 'SBUX', 'SCHW', 'SHW', 'SJM', 'SLB', 'SMCI', 'SNA', 'SNPS', 'SO', 'SPG', 'SPGI', 'SRE', 'STE', 'STLD', 'STT', 'STX', 'STZ', 'SWK', 'SWKS', 'SYF', 'SYK', 'SYY', 'T', 'TAP', 'TDG', 'TDY', 'TECH', 'TEL', 'TER', 'TFC', 'TFX', 'TGT', 'TJX', 'TMO', 'TMUS', 'TPR', 'TRGP', 'TRMB', 'TROW', 'TRV', 'TSCO', 'TSLA', 'TSN', 'TT', 'TTWO', 'TXN', 'TXT', 'TYL', 'UAL', 'UBER', 'UDR', 'UHS', 'ULTA', 'UNH', 'UNP', 'UPS', 'URI', 'USB', 'V', 'VICI', 'VLO', 'VMC', 'VRSK', 'VRSN', 'VRTX', 'VTR', 'VTRS', 'VZ', 'WAB', 'WAT', 'WBA', 'WDC', 'WEC', 'WFC', 'WM', 'WMB', 'WMT', 'WRB', 'WRK', 'WST', 'WTW', 'WY', 'WYNN', 'XEL', 'XOM', 'XYL', 'YUM', 'ZBH', 'ZBRA', 'ZTS']:
        for method in ["lr_0.001/max_genome_10000/island_10"]:
            for folder in range(25):

                exp_name="/home/zl7069/git/cluster_results/" + result_folder + "/"  + DATASET + "/" +  method + "/" + str(folder) + "/"
                genome_dir = examm + result_folder + "/"  +DATASET + "/" +  method + "/" + str(folder) + "/" 
                # print(genome_dir)
                global_best_genome = []
                if os.path.isdir(genome_dir):
                    files = os.listdir(genome_dir)
                    max=-1
                    genome=""
                    if len(files) > 0:
                        for file in files:
                            if file.endswith(".gv"):
                                num=int(file.split("_genome_")[1].split(".gv")[0])
                                if num > max:
                                    max = num
                                    genome = file
                                if "global_best" in file:
                                    global_best_genome = file 
                        
                        target = os.path.join(exp_name,genome)
                        genome = os.path.join(genome_dir,genome)
                        shutil.copyfile(genome, target)  
                        if (len(global_best_genome) > 0):
                            target_global_best = os.path.join(exp_name,global_best_genome)
                            global_best_genome = os.path.join(genome_dir,global_best_genome)
                            shutil.copyfile(global_best_genome, target_global_best) 
                    

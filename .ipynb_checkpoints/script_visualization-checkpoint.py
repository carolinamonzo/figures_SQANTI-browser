import pandas as pd
import matplotlib.pyplot as plt
import re

def parse_max_rss(rss_str):
    """Converts MaxRSS (e.g., '1515528K', '860M') to GB."""
    rss_str = str(rss_str).strip()
    if rss_str in ["0", "", "None", "NaN"]: return 0.0
    try:
        # Extract numeric part
        value = float(re.search(r"(\d+\.?\d*)", rss_str).group(1))
        # Determine unit
        unit = re.search(r"([KMGkmg])", rss_str)
        unit = unit.group(1).upper() if unit else 'K'
        
        if unit == 'K': return value / (1024 * 1024)
        if unit == 'M': return value / 1024
        if unit == 'G': return value
    except:
        return 0.0
    return 0.0

def parse_slurm_time(time_str):
    """
    Converts Slurm time (DD-HH:MM:SS, HH:MM:SS, MM:SS, or MM:SS.xxx) to total seconds.
    """
    time_str = str(time_str).strip()
    if time_str in ["0", "", "NaN", "N/A"]: return 0.0
    
    try:
        days = 0
        # Check for days (format DD-HH:MM:SS)
        if '-' in time_str:
            days_part, time_str = time_str.split('-')
            days = int(days_part)
        
        parts = time_str.split(':')
        if len(parts) == 3: # HH:MM:SS
            h, m, s = parts
            total = (days * 86400) + (int(h) * 3600) + (int(m) * 60) + float(s)
        elif len(parts) == 2: # MM:SS or MM:SS.xxx
            m, s = parts
            total = (days * 86400) + (int(m) * 60) + float(s)
        else:
            total = float(time_str)
        return total
    except:
        return 0.0

# 1. Load data with space separator
df = pd.read_csv('times_memory.txt', sep='\s+', header=None, 
                 names=['JobID', 'JobName', 'Partition', 'MaxRSS_raw', 'Submit', 'End', 'User', 'Elapsed', 'Nodes', 'CPUs', 'ReqMem', 'TotalCPU', 'State', 'ExitCode'])

# 2. Process columns
df['MaxRAM_GB'] = df['MaxRSS_raw'].apply(parse_max_rss)
df['Elapsed_Sec'] = df['Elapsed'].apply(parse_slurm_time)
df['TotalCPU_Sec'] = df['TotalCPU'].apply(parse_slurm_time)

# 3. Handle Slurm's multi-line output per job
# We want to group by the base JobID (e.g., 2347199_0) and take the maximum values 
# found across all steps (.batch, .ba+, etc.)
df['BaseJobID'] = df['JobID'].str.replace(r'\..*', '', regex=True)

# Grouping ensures we get the memory from the .batch line and the time from the main line
df_plot = df.groupby('BaseJobID').agg({
    'MaxRAM_GB': 'max',
    'Elapsed_Sec': 'max',
    'TotalCPU_Sec': 'max'
}).reset_index()

# Filter out entries where no time was recorded (to avoid empty plots)
df_plot = df_plot[df_plot['Elapsed_Sec'] > 0].sort_values('BaseJobID')

# 4. Plotting
fig, axes = plt.subplots(1, 3, figsize=(20, 6))

data_to_plot = [
    ('MaxRAM_GB', 'Peak RAM Usage (GB)', '#1A87B9'),
    ('TotalCPU_Sec', 'Total CPU Time (Sec)', '#E67E22'),
    ('Elapsed_Sec', 'Wall-Clock Time (Sec)', '#27AE60')
]

for i, (col, title, color) in enumerate(data_to_plot):
    axes[i].bar(df_plot['BaseJobID'], df_plot[col], color=color)
    axes[i].set_title(title, fontweight='bold')
    axes[i].set_ylabel(col.split('_')[1] if '_' in col else col)
    axes[i].tick_params(axis='x', rotation=90)
    axes[i].grid(axis='y', linestyle='--', alpha=0.5)

plt.tight_layout()
plt.show()

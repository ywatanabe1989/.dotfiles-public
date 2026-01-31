# Spartan GPU Usage Cheat Sheet

## Interactive Session Commands
| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `module load slurm` | Load Slurm scheduler |
| [ ] | `module load cuda/11.7.0` | Load CUDA toolkit |
| [ ] | `squeue -u $USER` | Check your job status |
| [ ] | `sinfo -p gpu-a100-short` | Check GPU partition status |
| [ ] | `scancel <jobid>` | Cancel specific job |
| [ ] | `scontrol show job <jobid>` | Show detailed job info |
| [ ] | `sinteractive --partition=gpu-a100-short --gres=gpu:1 --time=4:00:00 --x11` | Request interactive GPU session |
| [ ] | `nvidia-smi` | Check GPU usage |
| [ ] | `htop` | Check CPU/memory usage |
| [ ] | `watch -n 1 nvidia-smi` | Monitor GPU usage continuously |

## Batch Job Commands
| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `sbatch job.slurm` | Submit batch job |
| [ ] | `scontrol show nodes` | Show node details |
| [ ] | `sacct -j <jobid>` | Show job accounting info |
| [ ] | `squeue --start` | Show estimated start times |
| [ ] | `sacct -X -o JobID,Submit,Start,End,State` | Show job history |
| [ ] | `scontrol hold <jobid>` | Hold job from starting |
| [ ] | `scontrol release <jobid>` | Release held job |

## Resource Options
```bash
--partition=gpu-a100-short    # Partition selection
--gres=gpu:1                 # Request 1 GPU
--time=4:00:00              # Request 4 hours
--mem=16G                   # Request 16GB memory
--cpus-per-task=1          # Request 1 CPU core
--nodes=1                  # Request 1 node
```

## Sample SLURM Script
```bash
#!/bin/bash
#SBATCH --job-name=gpu_job
#SBATCH --partition=gpu-a100-short
#SBATCH --gres=gpu:1
#SBATCH --time=4:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --output=%j.out
#SBATCH --error=%j.err

module load cuda/11.7.0
module load python/3.9.5
source /path/to/your/env/bin/activate
python your_script.py
```

Submit: `sbatch run_gpu.slurm`

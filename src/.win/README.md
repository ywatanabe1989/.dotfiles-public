<!-- ---
!-- Timestamp: 2025-04-10 09:17:32
!-- Author: ywatanabe
!-- File: /ssh:sp:/home/ywatanabe/proj/neurovista/data/hdf5/README.md
!-- --- -->

# HDF5 Format of NeuroVista Dataset

This directory contains the NeuroVista ECoG dataset converted from MATLAB format into HDF5 format. Each HDF5 file stored millions of 1-minute MATLAB files for a single patient.

# Metadata
- patient ID
- sampling rate
- recording dates

## How is it created?
These HDF5 files were generated using scripts that concatenate the original MATLAB files. See:
- Script: `../../scripts/dataset/concatenate_mat_files.py`
- Wrapper: `../../scripts/dataset/concatenate_mat_files.sh`

## Usage
- The contents of an HDF5 file can be explored using standard tools like `h5py` in Python.
- However, prepared class `ECoGDataReader` (defined in `./scripts/dataset/ECoGDataReader.py`) may be useful. Example usages can be found here `./examples/load_data.py`

## Tree

```
(SpartanGPU) hdf5 $ pwd
/home/ywatanabe/proj/neurovista/data/hdf5
(SpartanGPU) hdf5 $ date
Thu Apr 10 09:16:17 AM AEST 2025
(SpartanGPU) hdf5 $ tree -h
.
├── [ 296G]  Patient_23_002.h5
├── [ 365G]  Patient_23_003.h5
├── [ 105G]  Patient_23_005.h5
├── [  92G]  Patient_23_006.h5
├── [  86G]  Patient_24_001.h5
├── [ 235G]  Patient_24_002.h5
├── [ 230G]  Patient_24_005.h5
├── [ 368G]  Patient_25_003.h5
├── [ 1.7K]  README.md
└── [ 4.0K]  scripts
    ├── [  23K]  concatenate_mat_files.py
    ├── [ 1.6K]  concatenate_mat_files.sh
    ├── [  26K]  ECoGDataReader.py
    └── [  12K]  example_data_loading.py

1 directory, 13 files
(SpartanGPU) hdf5 $ 
```

## Contact
Yusuke.Watanabe@unimelb.edu.au

<!-- EOF -->
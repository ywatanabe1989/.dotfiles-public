<!-- ---
!-- Timestamp: 2025-03-08 12:25:50
!-- Author: ywatanabe
!-- File: /home/ywatanabe/.dotfiles/.bash.d/all/010_apptainer/apptainer-utils/README.md
!-- --- -->


# Apptainer Utils

Collection of utilities for managing Apptainer/Singularity containers.

## Installation

#### Apptainer itself
1. `$ source src/install_apptainer.src && install_apptainer`
2. `$ source src/enable_fakeroot.src && apptainer_enable_fakeroot`

#### Apptainer Utilities

```bash
1. `$ source /path/to/apptainer_utilities/src/entry.src` # in ~/.bashrc

2. Place containers in:
   - Global: `$HOME/.apptainer/`
   - Project-specific: `./.apptainer/`
```

## Initialize/Update Directory Structure

``` bash
$ apptainer_init_or_update_dir -c project_A # adir -c project_A
$ apptainer_init_or_update_dir -c project_B # adir -c project_B
# Container directory structure updated successfully
#  
# ./.apptainer
# ├── image.sandbox -> project_B/project_B.sandbox
# ├── image.sif -> project_B/project_B.sif
# ├── project_A
# │   ├── definitions
# │   │   ├── differences
# │   │   ├── project_A_latest.def -> project_A_v001.def
# │   │   └── project_A_v001.def
# │   ├── project_A.def -> definitions/project_A_v001.def
# │   ├── project_A.sandbox
# │   ├── project_A.sandbox.log
# │   ├── project_A.sif
# │   └── project_A.sif.log
# └── project_B
#     ├── definitions
#     │   ├── differences
#     │   ├── project_B_latest.def -> project_B_v001.def
#     │   └── project_B_v001.def
#     ├── project_B.def -> definitions/project_B_v001.def
#     ├── project_B.sandbox
#     ├── project_B.sandbox.log
#     ├── project_B.sif
#     └── project_B.sif.log
#  
# 7 directories, 16 files
#  
# You might want to:
#     - Implement ./.apptainer/project_B/definitions/project_B.def
#     - Make ./.apptainer/project_B/definitions/project_B.def
#     - Update symlinks ./.apptainer/image.{sif,sandbox}
```

## Environment Variables 

| Variable | Description | Default |
|----------|-------------|---------|
| `APPTAINER_GLOBAL_DIR` | Global container dir | `$HOME/.apptainer/` |
| `APPTAINER_LOCAL_DIR` | Local container dir | `./.apptainer/` |
| `APPTAINER_RUNTIME_OPTIONS` | Default runtime options | `"--fakeroot --nv"` |
| `APPTAINER_WRITABLE_OPTIONS` | Default runtime options | `"--fakeroot --cleanenv --writable"` |

## Commands

### Sandbox Operations
| Scope | Alias | Function | Description |
|-------|-------|----------|-------------|
| Local | `ashell_s` | `apptainer_shell_sandbox_local` | Shell into local sandbox |
| Local | `ashell_sw` | `apptainer_shell_sandbox_local_writable` | Shell into writable local sandbox |
| Global | `ashell_sg` | `apptainer_shell_sandbox_global` | Shell into global sandbox |
| Global | `ashell_sgw` | `apptainer_shell_sandbox_global_writable` | Shell into writable global sandbox |

### Static Container Operations
| Scope | Alias | Function | Description |
|-------|-------|----------|-------------|
| Local | `apy` | `apptainer_exec_static_local_python` | Run Python in local container |
| Local | `aipy` | `apptainer_exec_static_local_ipython` | Run IPython in local container |
| Local | `ajpy` | `apptainer_exec_static_local_jupyter` | Run Jupyter in local container |
| Global | `apy_g` | `apptainer_exec_static_global_python` | Run Python in global container |
| Global | `aipy_g` | `apptainer_exec_static_global_ipython` | Run IPython in global container |
| Global | `ajpy_g` | `apptainer_exec_static_global_jupyter` | Run Jupyter in global container |

### Builder Operations
| Alias | Function | Description |
|-------|----------|-------------|
| `abuild_def2sif` | `apptainer_build_def_to_sif` | Build SIF from def file |
| `abuild_def2sand` | `apptainer_build_def_to_sandbox` | Build sandbox from def |
| `abuild_sand2sif` | `apptainer_build_sandbox_to_sif` | Convert sandbox to SIF |
| `abuild_sif2sand` | `apptainer_build_sif_to_sandbox` | Convert SIF to sandbox |


## License

MIT License

## Contact

ywatanabe@alumni.u-tokyo.ac.jp

<!-- EOF -->
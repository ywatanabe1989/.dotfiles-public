# PATH
export PATH=$HOME/.bin:$HOME/.local/bin:$HOME/local/python/bin:/usr/local/bin:/usr/local/cuda/bin:$HOME/.ssh/bin:$PATH

if-host "ywata" \
           export PATH=/opt/emacs-29.3/bin:/opt/mu-1.6.10/:$PATH
if-host "nsurg" \
           export PATH=$HOME/.singularity/.bin:$PATH

# Python
export PYTHONPATH=.:./externals/:$HOME/.py:$PYTHONPATH
export PYTHONSTARTUP=$HOME/.pystartup

# CUDA
if [[ -d /usr/local/cuda && $PATH != *'/usr/local/cuda/bin'* ]]; then
    export CUDA_HOME=/usr/local/cuda
    export PATH=/usr/local/cuda/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
fi

if-host "ywata" \
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib

# Man
export MANPATH=$HOME/usr/share/man:$MANPATH

# PKG_CONFIG
export PKG_CONFIG_PATH=$HOME/usr/lib/pkgconfig:$PKG_CONFIG_PATH

# CPATH
export CPATH=$HOME/usr/include:$CPATH

# OpenDevin
export OPENDEVIN_WORKSPACE=$(pwd)/workspace

# Screen
export SCREENDIR=$HOME/.screen

export EMACS_GENAI_DIR="$HOME/.emacs.d/lisp/genai/"


remove_duplicate_paths() {
    local PATH_VAR_NAME=$1
    local ORIGINAL_PATH=$(eval echo \$$PATH_VAR_NAME)
    local NEW_PATH=""
    local DIR

    IFS=':' read -ra ADDR <<< "$ORIGINAL_PATH"
    for DIR in "${ADDR[@]}"; do
        if [[ ":$NEW_PATH:" != *":$DIR:"* ]]; then
            NEW_PATH="${NEW_PATH:+$NEW_PATH:}$DIR"
        fi
    done

    export $PATH_VAR_NAME="$NEW_PATH"
}

remove_duplicate_paths PATH
remove_duplicate_paths CUDA_HOME
remove_duplicate_paths LD_LIBRARY_PATH
remove_duplicate_paths PYTHONPATH
remove_duplicate_paths MANPATH
remove_duplicate_paths PKG_CONFIG_PATH
remove_duplicate_paths CPATH

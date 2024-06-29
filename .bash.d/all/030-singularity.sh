#!/bin/bash

################################################################################
## Installation
##
## 1. Place this file in $HOME as ~/singularity-aliases.sh
## 2. Add the line ". $HOME/singularity-aliases.sh" to automatically load this file
## 3. Store your sif file or sandbox directory under SG_HOME_DIR or SG_WORK_DIR as follows:
##
## .project_A/.singularity
## ├── project_A.sif # project_A.sif
## ├── project_A # project_A
## ├── image.sif (symlink -> project_A.sif)
## └── image (symlink -> project_A)
################################################################################

################################################################################
# Fixed environmental variables
################################################################################
# PATH
export SINGULARITY_BIN_DIR="$HOME/.singularity/.bin"
mkdir -p $SINGULARITY_BIN_DIR

export SINGULARITYENV_PATH=$(echo "$PATH" | tr ":" "\n" | grep -v $SINGULARITY_BIN_DIR | tr "\n" ":" | sed "s/:$//")

export SINGULARITYENV_PYTHONPATH=$PATHONPATH
export SINGULARITYENV_PYTHONSTARTUP=$PYTHONSTARTUP
export SINGULARITYENV_CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES

# Base
export SINGULARITYENV_USER=$USER
export SINGULARITYENV_MYHOME=$MYHOME # $SINGULARITYENV_HOME is prohibited
export SINGULARITYENV_DISPLAY=$DISPLAY
export SINGULARITYENV_OUTDATED_IGNORE=$OUTDATED_IGNORE
export SG_HOME_DIR="$HOME/.singularity/"
export SG_CD_DIR="./.singularity/"
export SG_STATIC_SIF="image.sif"
export SG_SAND_SIF="sandbox"

# Static
export SG_STATIC_SIF_HOME_PATH=${SG_HOME_DIR}${SG_STATIC_SIF}
export SG_STATIC_SIF_CD_PATH=${SG_CD_DIR}${SG_STATIC_SIF}
export SG_SAND_SIF_HOME_PATH=${SG_HOME_DIR}${SG_SAND_SIF}
export SG_SAND_SIF_CD_PATH=${SG_CD_DIR}${SG_SAND_SIF}


################################################################################
# Adjustabale environmental variables
################################################################################

########################################
# Current directory for project-level work, targettting ./.singularity in default
########################################

#### Working with static .sif files, located as ./.singularity/image.sif in default
sshell() { ee "singularity shell $SG_BASE_OPTIONS $SG_STATIC_SIF_CD_PATH"; }
_spy () {
    BIN=$1
    shift
    ee "singularity exec --fakeroot --cleanenv --nv $SG_STATIC_SIF_CD_PATH $BIN $@"
}
spy () { _spy python; }
sipy () { _spy ipython; }
sjpy () { _spy jupyter-notebook; }

#### Working with sandbox containers, located as ./.singularity/sandbox in default
sshell-sand() { ee "singularity shell -f -c --nv $SG_SAND_SIF_CD_PATH"; }
sshell-sand-w() {
    ee "unset SINGULARITY_BIND; singularity shell -f -c --writable $SG_SAND_SIF_CD_PATH"
}
_spy-sand () {
    BIN=$1
    shift
    ee "singularity exec $SG_BASE_OPTIONS $SG_SAND_SIF_CD_PATH $BIN $@"
}
spy-sand () { _spy-sand python; }
sipy-sand () { _spy-sand ipython; }
sjpy-sand () { _spy-sand jupyter-notebook; }

########################################
# Home directory for general purposes, targetting $HOME/.singularity in default
########################################
#### Working with static .sif files, located as $HOME/.singularity/image.sif in default
sshell-home() { ee "singularity shell $SG_BASE_OPTIONS $SG_STATIC_SIF_HOME_PATH"; }
_spy-home () {
    BIN=$1
    shift
    ee "singularity exec --fakeroot --cleanenv --nv $SG_STATIC_SIF_HOME_PATH $BIN $@"
}
spy-home () { _spy-home python; }
sipy-home () { _spy-home ipython; }
sjpy-home () { _spy-home jupyter-notebook; }

#### Working with sandbox containers, located as $HOME/.singularity/sandbox in default
sshell-sand-home() { ee "singularity shell -f -c --nv $SG_SAND_SIF_HOME_PATH"; }
sshell-sand-home() {
    ee "unset SINGULARITY_BIND; singularity shell -f -c --writable $SG_SAND_SIF_HOME_PATH"
}
_spy-sand-home () {
    BIN=$1
    shift
    ee "singularity exec $SG_BASE_OPTIONS $SG_SAND_SIF_HOME_PATH $BIN $@"
}
spy-sand-home () { _spy-sand-home python; }
sipy-sand-home () { _spy-sand-home ipython; }
sjpy-sand-home () { _spy-sand-home jupyter-notebook; }

################################################################################
## Build commands
################################################################################
_organize-sand() {
    DEFINITION_FILE=$1
    SANDBOX_FILE=$2
    LOG_FILE=$3

    # Extract the base name without extension
    BASE_DIR="${DEFINITION_FILE%.*}"/
    DEF_DIR="${BASE_DIR%}"../definition_files/

    # Create directories if they don't exist
    mkdir -p "$BASE_DIR" "$DEF_DIR"

    cp -v $DEFINITION_FILE $DEF_DIR
    mv -v $DEFINITION_FILE $SANDBOX_FILE $LOG_FILE $BASE_DIR
    }

_sbuild () {
    DEFINITION_FILE=$1
    IMAGE_PATH=$2
    LOG_PATH=$3
    shift 3
    OPTIONS="$@"

    # Calculation
    BASE_NAME="${DEFINITION_FILE%.*}"
    ORIG_DIR=`pwd`

    if [[ ! -f "$DEFINITION_FILE" ]]; then
        echo "Error: Definition file does not exist."
        return 1
    fi

    # Main
    ORIG_SINGULARITY_BIND=$SINGULARITY_BIND
    unset SINGULARITY_BIND
    ee "singularity build $OPTIONS $IMAGE_PATH $DEFINITION_FILE 2>&1 | tee ${LOG_PATH}"
    export SINGULARITY_BIND=$ORIG_SINGULARITY_BIND
}

sbuild () {
    # Example:
    # $ sbuild <YOUR_AWESOME_RECIPE>.def --fakeroot --remote # -> <YOUR_AWESOME_RECIPE>.sif

    DEFINITION_FILE=$1
    shift
    OPTIONS="$@"

    # Main
    BASE_NAME="${DEFINITION_FILE%.*}"
    STATIC_IMAGE_PATH=${BASE_NAME}.sif
    LOG_PATH=${BASE_NAME}.log

    _sbuild "$DEFINITION_FILE" "$STATIC_IMAGE_PATH" "$LOG_PATH" "$OPTIONS"

}

sbuild-sand() {
    # Example:
    # $ sbuilds <YOUR_AWESOME_RECIPE>.def --fakeroot --remote # -> <YOUR_AWESOME_RECIPE>

    DEFINITION_FILE=$1
    shift
    OPTIONS="$@"

    # Main
    BASE_NAME="${DEFINITION_FILE%.*}"
    SAND_IMAGE_PATH=${BASE_NAME}-sandbox
    LOG_PATH=${BASE_NAME}-sandbox.log

    _sbuild "$DEFINITION_FILE" "$SAND_IMAGE_PATH" "$LOG_PATH" --fix-perms --sandbox "$OPTIONS"
    if [ -d "$SAND_IMAGE_PATH" ]; then
        _organize-sand "$DEFINITION_FILE" "$SAND_IMAGE_PATH" "$LOG_PATH"
    fi
}

# rebuild the lasted def file undef definition_files dir
sbuild-sand-latest-again() {
    latest_def_file=$(ls -t ./definition_files/*.def | head -n 1)
    cp $latest_def_file .
    latest_def_fname=`basename $latest_def_file`
    yes | sbuild-sand ./.singularity/$latest_def_fname -f

    ln -sf $latest_def_fname/$latest_def_fname-sandbox sandbox
    ln -sf $latest_def_fname/$latest_def_fname-sandbox tools-sandbox
}

sbuild-latest-again() {
    latest_def_file=$(ls -t ./definition_files/*.def | head -n 1)
    cp $latest_def_file .
    latest_def_fname=`basename $latest_def_file`
    yes | sbuild ./.singularity/$latest_def_fname -f

    ln -sf $latest_def_fname/image.sif image.sif
    ln -sf $latest_def_fname/image.sif tools.sif
}

# EOF

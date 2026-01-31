#!/bin/bash

IGNORE_PATTERN="^\.(git|travis)"

echo "Create dotfile links."
for dotfile in .??*; do
    [[ $dotfile =~ $IGNORE_PATTERN ]] && continue
    # ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
    echo ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done
echo "Success"













# DOTFILES_DIR='../dotfiles'
# TODAY=`date +%Y-%m-%d-%H:%M`

# for fpath in $DOTFILES_DIR/.*; do
#     fpath_back=${fpath}_back_$TODAY
#     # mv ${fpath} ${fpath_back}
#     echo "mv ${fpath} ${fpath_back}"
# done
    
## EOF    

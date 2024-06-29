# Initialize an empty directory stack
MAX_DIR_HISTORY=7
# DIR_STACK=() # ~/.bash_profile

# # Function to add current directory to stack
# push_dir() {
#     local current_dir=$(pwd)
#     local new_stack=("$current_dir")
#     local count=1

#     # Iterate through existing stack, skipping duplicates and maintaining order
#     for dir in "${DIR_STACK[@]}"; do
#         if [[ "$dir" != "$current_dir" && $count -lt $MAX_DIR_HISTORY ]]; then
#             new_stack+=("$dir")
#             ((count++))
#         fi
#     done

#     # Update DIR_STACK with the new sorted stack
#     DIR_STACK=("${new_stack[@]}")
# }

# Function to add current directory to stack
push_dir() {
    local current_dir=$(pwd)
    DIR_STACK=("$current_dir" "${DIR_STACK[@]}")

    # Trim the stack to keep only the latest 7 entries
    if [ ${#DIR_STACK[@]} -gt 7 ]; then
        DIR_STACK=("${DIR_STACK[@]:0:7}")
    fi
}

# # Function to display the current directory stack
# cd-list() {
#     # echo "Current directory stack (most recent first):"
#     local stack_size=${#DIR_STACK[@]}
#     local display_count=$((stack_size < 7 ? stack_size : 7))

#     for ((i=0; i<display_count; i++)); do
#         printf "%2d: %s\n" $((-i-1)) "${DIR_STACK[i]}"
#     done
# }

# # Function to add current directory to stack
# push_dir() {
#     local current_dir=$(pwd)
#     DIR_STACK=("$current_dir" "${DIR_STACK[@]}")

#     # Trim the stack to keep only the latest 7 entries
#     if [ ${#DIR_STACK[@]} -gt 7 ]; then
#         DIR_STACK=("${DIR_STACK[@]:0:7}")
#     fi
# }
# Function to display the current directory stack
cd-list() {
    # echo "Current directory stack (most recent first):"
    local stack_size=${#DIR_STACK[@]}
    local display_count=$((stack_size < 7 ? stack_size : 7))

    for ((i=display_count-1; i>=0; i--)); do
        printf "%2d: %s\n" $((-i)) "${DIR_STACK[i]}"
    done

}

# Function to change directory and update stack
cd() {
    builtin cd "$@"
    if [[ -d ./env ]]; then
        source ./env/bin/activate
    else
        if command -v deactivate &> /dev/null; then
            deactivate 2>/dev/null
        fi

    fi
    push_dir
}

# # Function to display the current directory stack
# cd-list() {
#     # echo "Current directory stack (most recent last):"
#     local stack_size=${#DIR_STACK[@]}

#     for ((i=0; i<stack_size; i++)); do
#         local display_index=$(( i - stack_size + 1 ))
#         if [[ $display_index -eq 0 ]]; then
#             printf " %2d: %s\n" $display_index "${DIR_STACK[i]}"
#         else
#             printf "%3d: %s\n" $display_index "${DIR_STACK[i]}"
#         fi
#     done
# }

# Function to go to next directory
cd-next() {
    if [ ${#DIR_STACK[@]} -eq 0 ]; then
        echo "No next directory in stack"
    else
        next_dir="${DIR_STACK[-1]}"
        DIR_STACK=("${DIR_STACK[@]:0:${#DIR_STACK[@]}-1}")
        builtin cd "$next_dir"
        echo "Changed to: $next_dir"
    fi
}

# Function to go to previous directory
cd-prev() {
    if [ ${#DIR_STACK[@]} -lt 2 ]; then
        echo "No previous directory in stack"
    else
        prev_dir="${DIR_STACK[-2]}"
        DIR_STACK=("${DIR_STACK[@]:0:${#DIR_STACK[@]}-2}")
        builtin cd "$prev_dir"
        echo "Changed to: $prev_dir"
    fi
}

# Function for updating the default directory to cd in ~/.bashrc
set-current-directory ()
{
    # Define markers
    START_MARKER="### scd start ###"
    END_MARKER="### scd end ###"

    # Temporary file to hold new settings
    TMP_FILE=$(mktemp)

    # Create the new settings block
    echo "$START_MARKER" > $TMP_FILE
    echo "cd $(pwd)" >> $TMP_FILE
    echo "if [ -f env/bin/activate ]; then" >> $TMP_FILE
    echo "    source env/bin/activate" >> $TMP_FILE
    echo "fi" >> $TMP_FILE
    echo "$END_MARKER" >> $TMP_FILE

    # Backup the original .bashrc file
    cp ~/.bashrc ~/.bashrc.bak

    # Remove old block if it exists
    sed -i "/$START_MARKER/,/$END_MARKER/d" ~/.bashrc

    # Append new block to the end of .bashrc
    cat $TMP_FILE >> ~/.bashrc

    # Remove the temporary file
    rm $TMP_FILE
}


# to Parent directoreis
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'

# jump
alias dot='cd ~/.dotfiles'


# Aliases
alias scd="set-current-directory"
alias cdn="cd-next"
alias cdp="cd-prev"
alias cdl="cd-list"

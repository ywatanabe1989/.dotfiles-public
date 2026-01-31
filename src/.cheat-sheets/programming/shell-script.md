# Shell Script Cheat Sheet

## 1. Basic Structure
#!/bin/bash
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/another_script.sh"

## 2. Variables and Arrays
# Simple variable
variable_name="value"
echo "$variable_name"

# Array definition
my_array=("item1" "item2" "item3")
# or multiline
my_array=(
    "item1"
    "item2"
    "item3"
)

# Array operations
echo "${my_array[0]}"      # First element (index 0)
echo "${my_array[@]}"      # All elements
echo "${#my_array[@]}"     # Array length

# Loop through array
for item in "${my_array[@]}"; do
    echo "$item"
done

## 3. Control Structures
# If condition
if [ condition ]; then
    command
elif [ condition ]; then
    command
else
    command
fi

# Loops
for i in {1..5}; do
    echo "$i"
done

while [ condition ]; do
    command
done

## 4. Functions
function_name() {
    echo "First arg: $1"
    return 0
}

## 5. File Operations
[ -f file ]  # File exists
[ -d dir ]   # Directory exists
[ -x file ]  # File is executable

## 6. String/Number Operations
[ "$str1" = "$str2" ]   # String equality
[ $num1 -eq $num2 ]     # Numeric equality

## 7. Command Operations
result=$(command)       # Command substitution
alias cmd='command'     # Alias

## 8. Arguments
$1, $2      # First, second argument
$#          # Number of arguments
$@          # All arguments
shift       # Shift arguments left

## 9. Error Handling
set -e      # Exit on error
trap 'echo "Error: $LINENO"' ERR

## 10. Arithmetic
result=$((5 + 3))
((var++))
((var += 5))

## 11. Process Management
command &   # Background
wait        # Wait for completion

## 12. Redirection
command > file          # stdout to file
command 2> file        # stderr to file
command &> /dev/null   # Discard all output

## 13. Built-in Variables
$?          # Last exit status
$$          # Current PID
$RANDOM     # Random number

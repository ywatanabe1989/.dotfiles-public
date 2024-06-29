kill-grep() {
    pattern=$1
    if [[ -z $pattern ]]; then
        echo "Usage: kill-grep <pattern>"
        return 1
    fi
    matching_processes=$(ps aux | grep "$pattern" | grep -v grep)
    if [[ -z $matching_processes ]]; then
        echo "No processes found matching pattern: $pattern"
        return 1
    fi
    echo "Found the following processes for pattern '$pattern':"
    echo "$matching_processes"
    read -p "Do you want to kill these processes? (y/n) " answer
    if [[ $answer == "y" ]]; then
        echo "$matching_processes" | awk '{print $2}' | xargs -r kill -9
        echo "Processes killed."
    else
        echo "Aborted killing processes."
    fi
}

sudo-kill-grep() {
    pattern=$1
    if [[ -z $pattern ]]; then
        echo "Usage: sudo-kill-grep <pattern>"
        return 1
    fi
    matching_processes=$(ps aux | grep "$pattern" | grep -v grep)
    if [[ -z $matching_processes ]]; then
        echo "No processes found matching pattern: $pattern"
        return 1
    fi
    echo "Found the following processes for pattern '$pattern':"
    echo "$matching_processes"
    read -p "Do you want to kill these processes? (y/n) " answer
    if [[ $answer == "y" ]]; then
        echo "$matching_processes" | awk '{print $2}' | xargs -r sudo kill -9
        echo "Processes killed."
    else
        echo "Aborted killing processes."
    fi
}

kill-wata () {
    pkill -u watanabe
}


kill-py () {
    ps aux | grep ywatana+ | egrep 'python' | awk '{ print "kill", $2 }' | sh
    clear
    free
    sleep 2
    clear
}

kill-wata_py () {
    ps aux | grep ywatana+ | egrep 'python' | awk '{ print "kill", $2 }' | sudo sh
}

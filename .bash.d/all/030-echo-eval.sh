function echo_eval () {
    command=$1
    echo "$command"
    echo
    eval "$command"
}
alias ee='echo_eval'

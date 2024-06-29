function view-csv () {
    column -s, -t $1 | less
}

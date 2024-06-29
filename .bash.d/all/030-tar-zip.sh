# Creates an archive (*.tar.gz) from given directory.
function mktar() {
    local hostname=$(hostname)
    local date=$(date +%Y%m%d)
    tar cvzf "${1%%/}_${hostname}_${date}.tar.gz" "${1%%/}/"
}

function lstar() {
    local tmpdir=$(mktemp -d)
    tar -xzf "$1" -C "$tmpdir"
    # git-tree "$tmpdir"
    tree "$tmpdir"
    rm -rf "$tmpdir"
}


# Create a ZIP archive of a file or folder.
function mkzip() { zip -r "${1%%/}.zip" "$1" ; }

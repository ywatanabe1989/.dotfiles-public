# alias g='git'
# alias st='git status'
# alias br='git branch'
# alias sw='git switch'
# alias ch='git checkout'
# alias fetch='git fetch'

parse_args() {
    local OPTIND
    TARGET_DIR="."
    while getopts ":t:" opt; do
        case $opt in
            t) TARGET_DIR="$OPTARG"
               ;;
            \?) echo "Invalid option -$OPTARG" >&2
               return 1
               ;;
        esac
    done
    shift $((OPTIND-1))
    ARGS=("$@")
}

alias g='git'
# alias st='git status'

st() {
    parse_args "$@"
    (
        cd "$TARGET_DIR" || exit
        git status
    )
}

alias br='git branch'
alias sw='git switch'
alias ch='git checkout'
alias fetch='git fetch'

ad() {
    parse_args "$@"
    (
        cd "$TARGET_DIR" || exit
        if [ ${#ARGS[@]} -eq 0 ]; then
            git add .
        else
            for arg in "${ARGS[@]}"; do
                git add "$arg"
            done
        fi
    )
}

# cm() {
#     parse_args "$@"
#     (
#         cd "$TARGET_DIR" || exit
#         if [ ${#ARGS[@]} -eq 0 ]; then
#             now=$(date +'%Y-%m-%d-%H-%M-%S')
#             git commit -m "update-$now"
#         else
#             git commit -m "${ARGS[*]}"
#         fi
#     )
# }

cm() {
    parse_args "$@"
    (
        cd "$TARGET_DIR" || exit
        if [ ${#ARGS[@]} -eq 0 ]; then
            now=$(date +'%Y-%m-%d-%H-%M-%S')
            message="update-$now"
        else
            message="${ARGS[*]}"
        fi

        # Try genai-commit first
        if command -v genai-commit &> /dev/null; then
            # Attempt to run genai-commit
            if { genai-commit -m "$message"; } 2>/dev/null; then
                echo "Commit successful using genai-commit"
                return 0
            else
                echo "genai-commit failed or produced an error, falling back to regular git commit"
            fi
        else
            echo "genai-commit not found, using regular git commit"
        fi

        # Fall back to regular git commit
        git commit -m "$message"
    )
}

ac() {
    parse_args "$@"
    (
        cd "$TARGET_DIR" || exit
        ad . && cm "${ARGS[*]}"
    )
}

alias push='git push'

acp() {
    parse_args "$@"
    (
        cd "$TARGET_DIR" || exit
        ad . && cm "${ARGS[*]}" && git push
    )
}

acpl() {
    parse_args "$@"
    (
        cd "$TARGET_DIR" || exit
        acp "${ARGS[*]}"
        gh-pr-from-dev-to-main
    )
}

# ad () {
#     if [ $# -eq 0 ]; then
#         git add .
#     else
#         for arg in "$@"; do
#             git add "$arg"
#         done
#     fi
# }

# # alias cm="genai-commit"

# cm() {
#     if [ -z "$*" ]; then
#         now=`date +'%Y-%m-%d-%H-%M-%S'`
#         git commit -m "update-$now"
#     else
#         git commit -m "$*"
#     fi
# }

# ac() {
#     ad && cm "$*"
#     # git add .
#     # if [ -z "$*" ]; then
#     #     now=`date +'%Y-%m-%d-%H-%M-%S'`
#     #     git commit -m "update-$now"
#     # else
#     #     git commit -m "$*"
#     # fi
# }

# alias push='git push'

# acp() {
#     ad && cm "$*" && git push
# }

# acpl() {
#     acp "$*"
#     gh-pr-from-dev-to-main
# }

# alias acp='ad && cm && push'
# alias pull='git pull --no-edit'
# alias log="git log \
#                --graph \
#                --date=human \
#                --decorate=short \
#                --pretty=format:'%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s'"

# git-tree() {
#     git ls-tree -r --name-only HEAD | tree --fromfile
# }

pull() {
    parse_args "$@"
    (
        cd "$TARGET_DIR" || exit
        git pull --no-edit
    )
}

log() {
    parse_args "$@"
    (
        cd "$TARGET_DIR" || exit
        git log \
            --graph \
            --date=human \
            --decorate=short \
            --pretty=format:'%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s'
    )
}

git-tree() {
    parse_args "$@"
    (
        cd "$TARGET_DIR" || exit
        git ls-tree -r --name-only HEAD | tree --fromfile
    )
}

# cm-genai() {
#    echo `git status` \"\nGenerate commit message without any other lines as I will use your output to the commit message directly\" | xargs genai > commit_message
#     }

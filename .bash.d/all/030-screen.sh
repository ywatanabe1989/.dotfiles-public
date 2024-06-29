alias sb='screen -dmS' # background
alias sc='screen'
alias sd='screen -D'
alias sl='screen -list'
alias sr='screen -r'
alias ss='screen -S'
alias swipe='screen -wipe && screen -list'

sk () {
    screen -ls | grep $1 | cut -d. -f1 | awk '{print $1}' | xargs kill
    clear
    screen -list
}

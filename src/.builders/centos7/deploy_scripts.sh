#!/bin/bash
# https://qiita.com/b4b4r07/items/e56a8e3471fb45df2f59

declare -a deploy_arr=(dump_dconf.sh
                       encript_pw.sh
                       decript_pw.sh)

i=0
for e in ${deploy_arr[@]}; do
    sudo cp scripts/${e} /usr/local/bin/
    sudo chmod +x /usr/local/bin/${e}

    echo sudo cp scripts/${e} /usr/local/bin/
    echo sudo chmod +x /usr/local/bin/${e}
    echo

    let i++
done

## EOF

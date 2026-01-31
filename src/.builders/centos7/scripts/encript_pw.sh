#!/bin/bash

usage_exit() {
    echo "Usage: $0 [-p PW (def: hoge)] [-o OUT (def: \${HOME}/.pw/0.rsa)]" 1>&2
    echo
    echo "ex) $0 -p hogehgoe -o \${HOME}/.pw/1.rsa"
    echo "    ./decript_pw.sh -f \$HOME/.pw/1.rsa # hogehoge"
    echo
    echo "ex) $0 -p fuga -o \${HOME}/.pw/2.rsa"
    echo "    ./decript_pw.sh -f \$HOME/.pw/2.rsa # fuga"
        exit 1
}


## Default Values
PW="hoge"
KEY="${HOME}/.ssh/id_rsa"
mkdir ~/.pw
OUT="${HOME}/.pw/rsa"


while getopts :p:k:o:h OPT
do
  case $OPT in
      p) PW=$OPTARG;;
      k) KEY=$OPTARG;;
      o) OUT=$OPTARG;;
      h) usage_exit;;
  esac
done

## Parser
if [ ! -e $KEY ]; then
    ## Create New Key
    ssh-keygen -f $KEY -t rsa -N ""
    echo ssh-keygen -f $KEY -t rsa -N ""
fi


echo $PW | openssl rsautl -encrypt -inkey $KEY > $OUT
sudo chmod 0400 $KEY
sudo chmod 0400 $OUT
echo $OUT' was created'


## EOF

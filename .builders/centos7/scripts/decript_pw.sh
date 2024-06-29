#!/bin/bash

usage_exit() {
    echo "Usage: $0 [-f PW_FILE (def: \${HOME}/.pw/rsa)] [-k KEY (def: \${HOME}/.ssh/id_rsa)]" 1>&2
    echo
    echo "ex) $0 -f \${HOME}/.pw/rsa-1.rsa # hogehoge"
    echo
    echo "ex) $0 -f \${HOME}/.pw/rsa-2.rsa # fuga"
        exit 1
}


## Default Values
PW_FILE="${HOME}/.pw/rsa"
KEY="${HOME}/.ssh/id_rsa"


while getopts :f:k:h OPT
do
  case $OPT in
      f) PW_FILE=$OPTARG;;
      k) KEY=$OPTARG;;
      h) usage_exit;;
  esac
done


PW=`openssl rsautl -decrypt -inkey $KEY -in $PW_FILE`
echo $PW



## EOF

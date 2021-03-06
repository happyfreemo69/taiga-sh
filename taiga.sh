#!/bin/bash
function help(){
    echo "create ~/.taigarc with content below"
    echo taiga_username=xxx
    echo taiga_password=yy;
    exit 1
}
if [ ! -f ~/.taigarc ];then
    help
fi
source ~/.taigarc
if [ -z $taiga_username ] || [ -z $taiga_password ];then
    help
fi

cmds="ref at"
if [ -z "$1" ] || [ $(echo "$cmds"| grep -q "$1"; echo $?) -ne 0 ];then
    echo "expect ./taiga.sh $cmds"
    exit 1
fi
cmd="$1"
shift
for i in "$@";
do
case $i in
    -at=*|--at=*)
    AT="${i#*=}"
    ;;
    *)
    ;;
esac
done
#https://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac
function crossRealpath(){
    TARGET_FILE="$1"

    cd $(dirname "$TARGET_FILE")
    TARGET_FILE=$(basename "$TARGET_FILE")

    # Iterate down a (possible) chain of symlinks
    while [ -L "$TARGET_FILE" ]
    do
        TARGET_FILE=$(readlink "$TARGET_FILE")
        cd $(dirname "$TARGET_FILE")
        TARGET_FILE=$(basename "$TARGET_FILE")
    done

    # Compute the canonicalized name by finding the physical path 
    # for the directory we're in and appending the target file.
    PHYS_DIR=$(pwd -P)
    RESULT="$PHYS_DIR"/"$TARGET_FILE"
    echo $RESULT
}

exe="$(crossRealpath $0)"
projdir=$(echo $exe|sed 's:/taiga.sh$::')
if [ -z $AT ];then
    AT=$(bash $projdir/cmds/at.sh "$taiga_username" "$taiga_password")
    args="--at=$AT $@"
else
    args="$@"
fi

if [ $(echo -n $AT|wc -c) -lt 5 ];then
    echo "could not retrieve auth_token, check credentials"
    exit 1
fi
if [ "$cmd" == "at" ];then
    echo $AT
    exit 0;
fi
bash $projdir/cmds/"$cmd".sh $args
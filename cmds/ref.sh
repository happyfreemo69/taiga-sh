for i in "$@";
do
case $i in
    -at=*|--at=*)
    AT="${i#*=}"
    shift
    ;;
    *)
        ref="$i"
    ;;
esac
done

if [ -z $ref ];then
    echo "expect a taiga.sh ref {{number}} e.g:"
    echo "taiga.sh ref 4567"
    exit 1
fi

function process(){
    url=$1
    a=$(curl -4 -s "$url" -H "Authorization: Bearer $AT")
    echo $a|grep -q _error_message
    if [ "$?" -ne 0 ];then
        echo $a
    fi
}

process 'https://taiga.citylity.com/api/v1/issues/by_ref?ref='$ref'&project=1' &
process 'https://taiga.citylity.com/api/v1/userstories/by_ref?ref='$ref'&project=1' &
process 'https://taiga.citylity.com/api/v1/tasks/by_ref?ref='$ref'&project=1' &
wait
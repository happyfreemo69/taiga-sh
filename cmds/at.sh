username="$1"
password="$2"
AT=$(curl -4 -s -X POST https://taiga.citylity.com/api/v1/auth \
 -H 'Content-type: application/json' \
 --data '{ "type": "normal", "username": "'"$username"'", "password": "'"$password"'" }' \
 |grep -oE 'auth_token"[^"]+"[^"]+"'|cut -d'"' -f3)

echo $AT

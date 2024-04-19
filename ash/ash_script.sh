#!/bin/ash
#set -x
# IMPORTANT: FILL OUT THESE VARIABLES WITH YOUR OWN INFORMATION BEFORE RUNNING THE SCRIPT
cookie=''
user_id=''
password=''
service=''

urlencode() {
    local s="$1"
    local len=${#s}
    local i=0

    while [ $i -lt $len ]; do
        local c="${s:$i:1}"
        case "$c" in
            [a-zA-Z0-9.~_-])
                printf "$c"
                ;;
            ' ')
                printf '+'
                ;;
            *)
                printf '%%%02X' "'$c"
                ;;
        esac
        i=$((i + 1))
    done
}

# Fetch the initial URL and extract the redirect URL
script_text=$(curl -s 'http://123.123.123.123')
original_url=$(echo "$script_text" | sed -n "s/.*location.href='\([^']*\)'.*/\1/p")
encoded=$(urlencode $original_url)
echo "$encoded"

# Define the URL for POST request
url="http://eportal.hhu.edu.cn/eportal/InterFace.do"

# Make the POST request with verbose output for debugging
response=$(curl -v -s -o /dev/stderr -w "%{http_code}" \
  -H "Accept: */*" \
  -H "Accept-Encoding: gzip, deflate" \
  -H "Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6" \
  -H "Connection: keep-alive" \
  -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
  -H "Cookie: $cookie" \
  -H "Host: eportal.hhu.edu.cn" \
  -H "Origin: http://eportal.hhu.edu.cn" \
  -H "Referer: $original_url" \
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 Edg/123.0.0.0" \
  --data-raw "method=login&userId=user_id&password=$password&service=$service&queryString=$encoded&operatorPwd=&validcode=&passwordEncrypt=true" \
  "$url")

if [ "$response" -eq 200 ]; then
  echo "Success"
else
  echo "Error"
fi

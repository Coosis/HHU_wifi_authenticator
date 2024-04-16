#!/bin/bash
# IMPORTANT: FILL OUT THESE VARIABLES WITH YOUR OWN INFORMATION BEFORE RUNNING THE SCRIPT
cookie=''
user_id=''
password=''
service=''

response=$(curl -s 'http://123.123.123.123')

urlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""

    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9] ) o="${c}" ;;
            * )               printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done

    echo "${encoded}"
}

# Check if curl executed successfully
if [ $? -eq 0 ]; then
    # Use grep and sed to find and extract the URL from the response
	echo "$response"
    url_found=$(echo "$response" | grep -oP 'href=["'\'']\K(.*?)(?=["'\''])')

    if [ -n "$url_found" ]; then
        echo "URL found: $url_found"
    else
        echo "No URL found in the script. Either you're not connected to the campus's network, or you're connected and authenticated, therefore the script isn't necessary."
    fi
else
    echo "Failed to retrieve the webpage."
fi

encoded_url=$(urlencode "$url_found")
# echo "URL found: $encoded_url"

# Use curl to send a POST request with the extracted URL and other data
response=$(curl -s -X POST "http://eportal.hhu.edu.cn/eportal/InterFace.do?method=login" \
-H "Accept: */*" \
-H "Accept-Encoding: gzip, deflate" \
-H "Accept-Language: en,zh-TW;q=0.9,zh-CN;q=0.8,zh;q=0.7" \
-H "Origin: http://eportal.hhu.edu.cn" \
-H "Referer: $url_found" \
-H "Cookie: $cookie" \
-H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
--data-raw "userId=$user_id&password=$password&service=$service&queryString=$encoded_url&operatorPwd=&operatorUserId=&validcode=&passwordEncrypt=true")

echo "Login response: $response"

#!/bin/bash

# Array of possible response codes
response_codes=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")

<<comment
200: OK
201: Created
400: Bad Request
401: Unauthorized
403: Forbidden
404: Not Found
500: Internal Server Error
501: Not Implemented
502: Bad Gateway
503: Service Unavailable
comment

http_methods=("GET" "POST" "PUT" "PATCH" "DELETE")

# Array of possible user agents
user_agents=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/100.0"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36"
    "Opera/9.80 (Windows NT 6.0) Presto/2.12.388 Version/12.14"
    "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/48 (like Gecko) Version/12.0 Safari/48"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Trident/7.0; AS; rv:11.0) like Gecko"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edg/94.0.992.52 Safari/537.36"
    "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
    "MyUserAgent/1.0 (compatible; MyLibrary/2.0; +http://www.mylibrary.org)"
)

# List of possible URL components
protocols=("http" "https")
domains=("example.com" "test.net" "demo.org")
paths=("/" "/page" "/blog" "/products" "/about")
queries=("param1=value1&param2=value2" "id=123" "search=keyword")

# Output directory
output_dir="$(readlink -f "$(dirname "$0")/../nginx_logs")"
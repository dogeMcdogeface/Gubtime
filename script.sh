http_status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
echo "HTTP status code: $http_status "
# IMPORTANT: FILL OUT THESE VARIABLES WITH YOUR OWN INFORMATION
$cookie = ''
$user_id = ''
$password = ''
$service = ''

# assembly for making HTTP requests
Add-Type -AssemblyName System.Net.Http

# Create an HttpClient instance
$httpClient = [System.Net.Http.HttpClient]::new()
$originalUrl = ''

try {
    # Send a GET request to the specified URL
    $response = $httpClient.GetAsync('http://123.123.123.123').Result

    # Ensure the request was successful
    if ($response.IsSuccessStatusCode) {
        # Read the response content as a string
        $scriptText = $response.Content.ReadAsStringAsync().Result

        # Define a regex pattern to find the URL (handles both single and double quotes)
        $pattern = "href=['""](.*?)['""]"

        # Search for the pattern in the script text
        if ($scriptText -match $pattern) {
            # Extract the URL from the first capture group
            $originalUrl = $matches[1]
            Write-Output "URL found!"
        } else {
            Write-Output "No URL found in the script. "
			Write-Output "Either you're not connected to the campus's network or you're connected and authenticated, therefore the script isn't necessary."
        }
    } else {
        Write-Output "Failed to retrieve the webpage. Status code: $($response.StatusCode)"
    }
} catch {
    # Handle exceptions that occur during the request
    Write-Output "An error occurred: $_"
} finally {
    # Dispose of the HttpClient instance
    $httpClient.Dispose()
}
$encodedUrl = [uri]::EscapeDataString($originalUrl)


Invoke-WebRequest -UseBasicParsing -Uri "http://eportal.hhu.edu.cn/eportal/InterFace.do?method=login" `
-Method "POST" `
-WebSession $session `
-Headers @{
"Accept"="*/*"
  "Accept-Encoding"="gzip, deflate"
  "Accept-Language"="en,zh-TW;q=0.9,zh-CN;q=0.8,zh;q=0.7"
  "Origin"="http://eportal.hhu.edu.cn"
  "Referer"="$originalUrl"
  "cookie"="$cookie"
} `
-ContentType "application/x-www-form-urlencoded; charset=UTF-8" `
-Body "userId=$user_id&password=$password&service=$service&queryString=$encodedUrl&operatorPwd=&operatorUserId=&validcode=&passwordEncrypt=true"

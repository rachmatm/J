GOOGLE_CLIENT_ID = "1056251033952.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET = "fSNrvlAtliOnQXx3doMVod7e"
GOOGLE_OAUTH_URL = "https://accounts.google.com/o/oauth2/auth?" + 
                   "client_id=#{GOOGLE_CLIENT_ID}&" +
                   "redirect_uri=http://localhost:3000/oauth2callback&" +
                   "scope=https://gdata.youtube.com&" +
                   "response_type=code&" +
                   "access_type=offline"

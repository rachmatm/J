TWITTER_CONSUMER_KEY = "8FTo0LBkSE0jAMNX0KcUg"
TWITTER_CONSUMER_SECRET = "ke3obHG3YixzlxEYNzeMlUt4Htc72HJ1LMAAI476fYk"
TWITTER_TOKEN = "64200260-FUGVhcEkPDIzfNXpPb5Fdg6bHWUUOq07ZkpnQnJ6o"
TWITTER_SECRET = "PB7hYeUbLPmDpTa2qCCU7sTfFjUV7nKDymf9qj1xI"

class TwitterHelper
  def self.oauth_signature(method = "GET", url, oauth_secret, params)
    encoded_parameters = CGI.escape params.collect { |key, value| "#{key}=#{value}" }.join("&")
    signature_base = method.upcase + '&' + CGI.escape(url) + '&' + encoded_parameters
    signing_key = CGI.escape( TWITTER_CONSUMER_SECRET ) + '&' + CGI.escape(oauth_secret)
    return CGI.escape Base64.strict_encode64 OpenSSL::HMAC.digest 'sha1', signing_key, signature_base
  end
end

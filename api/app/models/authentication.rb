class Authentication
  include Mongoid::Document
  store_in :users

  attr_accessor :password

  # ---------------------------------------------------------------------------
  #
  # FIELD
  # ---------------------------------------------------------------------------
  #
  # -- Input Field
  field :username, :type => String
  field :realname, :type => String
  field :token, :type => String
  #
  # -- Facebook
  field :facebook_id, :type => String
  field :facebook_token, :type => String
  #
  # -- Twitter
  field :twitter_id, :type => String
  field :twitter_user_token, :type => String
  field :twitter_user_secret, :type => String

  # -- Google
  field :google_user_youtube_id, :type => String
  field :google_user_token, :type => String
  field :google_user_refresh_token, :type => String
  field :google_user_token_expires_at, :type => DateTime

  # -- Respond Field
  field :token, :type => String

  # -- Generated Field
  field :password_salt, :type => String
  field :password_hash, :type => String

  def reset_password(password_update, old_password)
    if password_update.length >= 6 and EncryptStringHelper.encrypt_string(old_password, self.password_salt)[:hash] == self.password_hash
      encrypted_string_data = EncryptStringHelper.encrypt_string(password_update)
      self.update_attributes :password_salt => encrypted_string_data[:salt], :password_hash => encrypted_string_data[:hash]

      return JsonizeHelper.format(:notice => "Password Update Suceeds")
    else
      error = password_update.length >= 6 ? "Your old password is incorrect" : "Password length needs to be at least 6 characters long" 
      return JsonizeHelper.format(:failed => true, :error => error)
    end
  end

  def self.set(username, password)
    auth_user = self.where(:username => username).first
    
    if auth_user.present? and 
       EncryptStringHelper.encrypt_string(password, auth_user.password_salt)[:hash] == auth_user.password_hash

      auth_user.update_attribute :token, ActiveSupport::SecureRandom.hex(9) unless auth_user.token.present?
       
      return JsonizeHelper.format(:token => auth_user.token) 
    else
      return JsonizeHelper.format(:error => "Invalid Username or Password", :failed => true) 
    end
  end

  def unset
    self.update_attributes :token => nil
    return JsonizeHelper.format(:notice => "You have successfully logged out")
  end

  def self.notify_forgot_password(email, client_url)
    if current_user = User.where(:email => /^#{email}$/i).first

      current_user.update_attributes :token => ActiveSupport::SecureRandom.hex(9)

      current_password = SecureRandom.hex(6)
      params = {:user => current_user, :url => client_url, :password => current_password}

      # Sending new password to the user
      ForgotPassword.forgot_password_email(params)

      return JsonizeHelper.format :notice => "An email is sent to your address, please check"
    else
      return JsonizeHelper.format :failed => true, :error => "Email is not registered"
    end
  end

  def self.reset_forgot_password(password, user_id)
    encrypted_string_data = EncryptStringHelper.encrypt_string(password)
    self.find(user_id).update_attributes :password_salt => encrypted_string_data[:salt], :password_hash => encrypted_string_data[:hash]
    return JsonizeHelper.format :notice => "You are confirmed, now please change the password to your liking"
  end

# Facebook
# ------------------------------------------------------------------------

  def self.current_user_facebook_authentication(code)
    parameter = { :client_id => FB_APP_ID, :redirect_uri => "http://localhost:3000/omniauth/authenticate_facebook", :client_secret => FB_SECRET_KEY, :code => code }
    facebook_token_response = Typhoeus::Request.get("https://graph.facebook.com/oauth/access_token", :params => parameter).body

    if facebook_token_response.empty? or facebook_token_response['error'].present?
      return "http://localhost:5000/omniauth/authenticate_facebook?error=Something%20went%20wrong,%20Please%20try%20again."
    else
      facebook_token = facebook_token_response.gsub(/access_token=(.+)/, '\1')
      facebook_access_profile_response = Typhoeus::Request.get("https://graph.facebook.com/me", :params => {:access_token => facebook_token}).body
      profile = ActiveSupport::JSON.decode facebook_access_profile_response
      jotky_token = ActiveSupport::SecureRandom.hex(9)
      user = self.find_or_create_by :realname => profile['name'],
        :username => profile['username'],
        :facebook_id => profile['id']

      user.update_attributes :token => jotky_token, :facebook_token => facebook_token
      return "http://localhost:5000/omniauth/authenticate_facebook?facebook_token=#{facebook_token}&jotky_token=#{jotky_token}"
    end
  end

# Twitter
# ------------------------------------------------------------------------

  def self.current_user_twitter_authentication(params)
    user = Authentication.find_or_create_by :username => params[:username], :realname => params[:realname], :twitter_id => params[:twitter_id]

    jotky_token = ActiveSupport::SecureRandom.hex(9)
    user.update_attributes :token => jotky_token, :twitter_user_token => params[:oauth_token], :twitter_user_secret => params[:oauth_secret]

    return JsonizeHelper.format :content => {:token => jotky_token}
  end

# Google
# ------------------------------------------------------------------------

  def self.current_user_google_authentication(code)
    body = "code=#{code}&client_id=#{GOOGLE_CLIENT_ID}&client_secret=#{GOOGLE_CLIENT_SECRET}&redirect_uri=http://localhost:3000/oauth2callback&grant_type=authorization_code"

    google_token_response = ActiveSupport::JSON.decode Typhoeus::Request.post("https://accounts.google.com/o/oauth2/token", :body => body).body

    if google_token_response.empty? or google_token_response['error'].present?
      return "http://localhost:5000/omniauth/authenticate_google?error=Something%20went%20wrong,%20Please%20try%20again."
    else
      google_token = google_token_response['access_token']
      google_profile_response = XmlSimple.xml_in Typhoeus::Request.get("https://gdata.youtube.com/feeds/api/users/default", :params => {:access_token => google_token}).body
      jotky_token = ActiveSupport::SecureRandom.hex(9)
      user = self.find_or_create_by :realname => google_profile_response['firstName'][0] + " " + google_profile_response['lastName'][0],
        :username => google_profile_response['username'][0],
        :google_user_youtube_id => google_profile_response['id'][0].gsub(/http:\/\/gdata.youtube.com\/feeds\/api\/users\/(.+)/, '\1')

      user.update_attributes :token => jotky_token, :google_user_token => google_token, :google_user_token_expires_at => Time.now + google_token_response['expires_in']
      user.update_attributes :google_user_refresh_token => google_token_response['refresh_token'] if google_token_response['refresh_token'].present?

      return "http://localhost:5000/omniauth/authenticate_google?username=#{user.username}&jotky_token=#{user.token}"
    end
  end
end

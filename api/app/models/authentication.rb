class Authentication
  include Mongoid::Document
  store_in :users

  

  # ---------------------------------------------------------------------------
  #
  # FIELD
  # ---------------------------------------------------------------------------
  #
  # -- Input Field
  field :username, :type => String
  attr_accessor :password
  field :facebook_secret, :type => String
  field :twitter_secret, :type => String

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
end

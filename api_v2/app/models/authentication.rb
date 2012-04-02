class Authentication
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in :users

  PRIVATE_FIELDS = [:password_salt, :password_hash]

  PROTECTED_FIELDS = []

  PUBLIC_FIELD = [:username]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = []

  RELATION_PUBLIC_DETAIL = []

  field :username, type: String
  field :email, type: String
  field :password_salt, :type => String
  field :password_hash, :type => String
  field :token, type: String
  field :avatar, type: String
  field :reset_forgot_password_token, type: String

  field :facebook_id, :type => String
  field :twitter_id, :type => String

  before_create :before_create_set_avatar

  def self.set(username, password)
    data = self.where(:username => username).first

    if data.present? and
        EncryptStringHelper.encrypt_string(password, data.password_salt)[:hash] == data.password_hash

      data.update_attribute :token, ActiveSupport::SecureRandom.hex(9)
      JsonizeHelper.format({:content => {:token => data.token}});
    else
      JsonizeHelper.format(:error => "Invalid Username or Password", :failed => true)
    end
  end

  def self.notify_forgot_password(email, base_url)
    user = self.where(:email => email).first
    
    if user.present?
      reset_password_token = ActiveSupport::SecureRandom.hex(11)
      user.update_attributes :forgot_password_token => reset_password_token
      user_mail = Mailer.new({:to => 'bimozx@gmail.com'})
      user_mail.reset_password_notification({}, {:reset_password_url => "http://localhost:5000/#!/change_password/#{reset_password_token}"})
      JsonizeHelper.format({:notice => 'Your confirmation letter have been sent, please check your email'})
    else
      JsonizeHelper.format({:failed => true, :error => 'Email is not registered, please try again'})
    end
  end

  def self.reset_forgot_password(password, reset_forgot_password_token)
    user = self.where(:reset_forgot_password_token => reset_forgot_password_token).first

    if user.present?
      user.set_secure_password(password)
      JsonizeHelper.format({:notice => 'You have updated your password'})
    else
      JsonizeHelper.format({:failed => true, :error => 'Your token does not match, please try again' })
    end
  end

  def self.set_by_facebook(secret_token)

    send_request = Typhoeus::Request.new "https://graph.facebook.com/me?access_token=#{secret_token}"
   
    # Run the request via Hydra.
    hydra = Typhoeus::Hydra.new
    hydra.queue(send_request)
    hydra.run

    response = send_request.response

    if response.success?
      data = ActiveSupport::JSON.decode(response.body)
   
      user = self.where(:facebook_id => data['id']).first

      unless user.present?
        user = self.new(:facebook_id => data['id']) unless user.present?
        user.save
      end

      user.update_attribute :token, ActiveSupport::SecureRandom.hex(9)
      JsonizeHelper.format({:content => user},{:except => NON_PUBLIC_FIELDS, :include => RELATION_PUBLIC})
    else
      JsonizeHelper.format(:error => "aw hell no, can\'t connect to facebook", :failed => true)
    end
  rescue
    JsonizeHelper.format(:error => "aw hell no, can\'t connect to facebook", :failed => true)
  end


  def self.set_by_twitter(token, secret)
    client = Twitter::Client.new :oauth_token => token, :oauth_token_secret => secret

    data = client.verify_credentials
    
    user = self.where(:twitter_id => data['id']).first

    unless user.present?
      user = self.new(:twitter_id => data['id'])
      user.save
    end

    user.update_attribute :token, ActiveSupport::SecureRandom.hex(9)
    JsonizeHelper.format({:content => user},{:except => NON_PUBLIC_FIELDS, :include => RELATION_PUBLIC})
  rescue
    JsonizeHelper.format(:error => "aw hell no, can\'t connect to twitter", :failed => true)
  end

  protected

  def set_secure_password
    encrypted_string_data = EncryptStringHelper.encrypt_string(password)
    self.password_salt = encrypted_string_data[:salt]
    self.password_hash = encrypted_string_data[:hash]
  end

  def before_create_set_avatar
    self.avatar = nil
  end
end

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
      
      data_user = User.find data.id

      JsonizeHelper.format({:content => data_user, :token => data.token}, {:except => User::NON_PUBLIC_FIELDS, :include => User::RELATION_PUBLIC})
    else
      JsonizeHelper.format(:error => "Invalid Username or Password", :failed => true)
    end
  end

  def self.notify_forgot_password(email, base_url)
    user = self.where(:email => email).first
    
    if user.present?
      reset_forgot_password_token = ActiveSupport::SecureRandom.hex(11)
      user.update_attributes :reset_forgot_password_token => reset_forgot_password_token

      user_mail = Mailer.new({:to => email})
      user_mail.reset_password_notification({}, {:reset_password_url => base_url + reset_forgot_password_token})

      JsonizeHelper.format({:notice => 'Your confirmation letter have been sent, please check your email'})
    else
      JsonizeHelper.format({:failed => true, :error => 'Email is not registered, please try again'})
    end
  end

  def self.reset_forgot_password(password, reset_forgot_password_token)
    user = self.where(:reset_forgot_password_token => reset_forgot_password_token).first

    if user.present? and password.length >= 6
      encrypted_string_data = EncryptStringHelper.encrypt_string(password)
      user.password_salt = encrypted_string_data[:salt]
      user.password_hash = encrypted_string_data[:hash]

      user.reset_forgot_password_token = nil

      user.save
      JsonizeHelper.format({:notice => 'You have updated your password'})
    else
      JsonizeHelper.format({:failed => true, :error => 'Your token does not match or your password is not long enough, please try again' })
    end
  end

  def self.set_by_facebook(secret_token)
    Connection.auth_facebook secret_token do |success, data|

      if success === true
        
        user = User.find_by_facebook_conn(data['id'])

        unless user.present?
          auth = self.create
          user = User.find auth.id
          user.set_conn_by_facebook(data['id'], secret_token, data['username'])
        end

        user.update_attribute :token, ActiveSupport::SecureRandom.hex(9)

        return JsonizeHelper.format({:content => user, :token => user.token},
          {:except => User::NON_PUBLIC_FIELDS, :include => User::RELATION_PUBLIC})
      else
        return JsonizeHelper.format(:error => "aw hell no, can\'t connect to facebook", :failed => true)
      end
    end
  end


  def self.set_by_twitter(token, secret)
    Connection.auth_twitter token, secret do |success, data|

      if success === true
        user = User.find_by_twitter_conn(data['id'])
  
        unless user.present?
          auth = self.create
          user = User.find auth.id
          user.set_conn_by_twitter(data['id'], token, secret, data['screen_name'])
        end

        user.update_attribute :token, ActiveSupport::SecureRandom.hex(9)

        return JsonizeHelper.format({:content => user, :token => user.token},
          {:except => User::NON_PUBLIC_FIELDS, :include => User::RELATION_PUBLIC})
      else
        return JsonizeHelper.format(:error => "aw hell no, can\'t connect to twitter", :failed => true)
      end

    end
  end

  protected

  def before_create_set_avatar
    self.avatar = nil
  end
end
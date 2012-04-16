class Registration
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in :users

  PRIVATE_FIELDS = [:password_salt, :password_hash]

  PROTECTED_FIELDS = [:facebook_id, :twitter_id, :user_id]

  PUBLIC_FIELD = [:username, :realname, :email, :password]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = []

  RELATION_PUBLIC_DETAIL = []

  attr_accessor :password, :user_id

  field :realname, type: String
  field :username, type: String
  field :email, type: String
  field :password_salt, :type => String
  field :password_hash, :type => String
  field :token, type: String
  field :avatar, type: String

  field :facebook_id, :type => String
  field :twitter_id, :type => String

  validates_format_of :username, :with => /^[A-Za-z0-9.\d_]+$/, :message => "can only be alphanumeric, dot and number with no spaces"
  validates_presence_of :realname, :username, :password, :email
  validates_length_of :username, :minimum => 5
  validates_length_of :password, :minimum => 6
  validates_uniqueness_of :username, :email, :case_sensitive => false

  before_create :set_secure_password, :before_create_set_avatar

  def self.set(paramaters, via_oauth = nil)
    paramaters.keep_if {|key, value| UPDATEABLE_FIELDS.include? key }

    if paramaters[:user_id].present?
      
      data = self.find paramaters[:user_id]
      data.update_attributes paramaters.merge :password => ActiveSupport::SecureRandom.hex(9)
    else
      data = self.create paramaters
    end

    if data.errors.present?
      
      JsonizeHelper.format :errors => data.errors.to_a.uniq, :failed => true, :error => "Registration doesn't succeed, please try again."
      
    elsif data.update_attributes :token => ActiveSupport::SecureRandom.hex(9)

      data_user = User.find data.id

      JsonizeHelper.format({:content => data_user, :token => data.token}, {:except => User::NON_PUBLIC_FIELDS, :include => User::RELATION_PUBLIC})

    else
      JsonizeHelper.format :failed => true, :error => 'Data Provider Error'
    end
  rescue
    JsonizeHelper.format :failed => true, :error => 'User not found'
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

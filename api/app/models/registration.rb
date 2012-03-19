#
# Registration.set({realname, username, email, password})
# => {Token}

class Registration
  include Mongoid::Document
  store_in :users

  attr_accessor :password

  field :realname, type: String
  field :username, type: String
  field :email, type: String
  field :password_salt, :type => String
  field :password_hash, :type => String
  field :token, type: String
  field :avatar, type: String

  validates_format_of :username, :with => /^[A-Za-z\d_]+$/, :message => "can only be alphanumeric with no spaces"
  validates_presence_of :realname, :username, :password, :email
  validates_length_of :username, :minimum => 5
  validates_length_of :password, :minimum => 6
  validates_uniqueness_of :username, :email, :case_sensitive => false

  key :username

  before_create :set_secure_password, :before_create_set_avatar

  DONT_INCLUDE_THESE_FIELDS = [
    :avatar_selected,
    :password_hash,
    :password_salt]

  PUBCLIC_FIELD = [
    :realname,
    :username,
    :email,
    :avatar]


  def self.set(params = {})
    data = self.create params

    if data.errors.present?
      JsonizeHelper.format :errors => data.errors.to_a, :failed => true, :error => "Registration doesn't succeed, please try again."
    elsif data.update_attributes :token => ActiveSupport::SecureRandom.hex(9)
      JsonizeHelper.format({:content => data.to_a, :token => data.token, :notice => "Signed In Successfully"})
    end
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

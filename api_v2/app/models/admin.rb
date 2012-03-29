class Admin
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :password

  field :username, :type => String
  field :password_salt, :type => String
  field :password_hash, :type => String

  attr_accessor :password

  validates_format_of :username, :with => /^[A-Za-z\d_]+$/, :message => "can only be alphanumeric with no spaces"
  validates_presence_of :username, :password
  validates_length_of :username, :minimum => 6
  validates_uniqueness_of :username, :case_sensitive => false

  before_create :before_create_set_secure_password

  def self.login(username, password)
    data = self.where(:username => username).first
    if data.present? and
      EncryptStringHelper.encrypt_string(password, data.password_salt)[:hash] == data.password_hash

      return data
    else
      return nil
    end
  end

  protected

  def before_create_set_secure_password
    encrypted_string_data = EncryptStringHelper.encrypt_string(password)
    self.password_salt = encrypted_string_data[:salt]
    self.password_hash = encrypted_string_data[:hash]
  end
end
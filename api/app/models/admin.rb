class Admin
  include Mongoid::Document

  attr_accessor :password

  # ---------------------------------------------------------------------------
  #
  # FIELD
  # ---------------------------------------------------------------------------
  #
  # -- Admin Information
  field :username, :type => String
  field :password_salt, :type => String
  field :password_hash, :type => String

  validates_format_of :username, :with => /^[A-Za-z\d_]+$/, :message => "can only be alphanumeric with no spaces"
  validates_presence_of :username, :password
  validates_length_of :username, :minimum => 6
  validates_uniqueness_of :username, :case_sensitive => false

  before_create :set_secure_password

  def self.login(username, password)
    login_admin = self.where(:username => username).first
    if login_admin.present? and 
      EncryptStringHelper.encrypt_string(password, login_admin.password_salt)[:hash] == login_admin.password_hash

      return login_admin
    else
      return nil
    end
  end

  # ---------------------------------------------------------------------------
  #
  # Callbacks
  # ---------------------------------------------------------------------------
  #
  private
  # Method to encrypt password that are registered
  def set_secure_password
    encrypted_string_data = EncryptStringHelper.encrypt_string(password)
    self.password_salt = encrypted_string_data[:salt]
    self.password_hash = encrypted_string_data[:hash]
  end
end
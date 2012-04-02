class Client
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :secret_key, :type => String
  field :reset_password_confirmation_url, :type => String

  before_save :before_save_set_name
  before_create :before_create_set_secret_key


  protected

  def before_create_set_secret_key
    self.secret_key = SecureRandom.hex(9)
  end

  def before_save_set_name
    self.name = RandomWord.adjs.next unless self.name.present?
  end
end

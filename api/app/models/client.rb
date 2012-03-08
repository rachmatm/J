class Client
  include Mongoid::Document
  
  # ---------------------------------------------------------------------------
  #
  # FIELD
  # ---------------------------------------------------------------------------
  #
  # -- Comment
  field :name, :type => String
  field :secret_key, :type => String
  field :reset_password_confirmation_url, :type => String

  # ---------------------------------------------------------------------------
  #
  # Callbacks
  # ---------------------------------------------------------------------------
  #
  before_save :set_name
  before_create :set_secret_key

  def set_secret_key
    self.secret_key = SecureRandom.hex(9)
  end

  def set_name
    self.name = "#{RandomWord.adjs.next} Application" unless self.name.present?
  end
end

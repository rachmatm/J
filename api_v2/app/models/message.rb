class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :to, :type => String
  field :from, :type => String
  field :subject, :type => String
  field :content, :type => String
  field :read, :type => Boolean, :default => false

  has_many :replies, :class_name => "Message", :inverse_of => :original_message, :dependent => :delete
  belongs_to :original_message, :class_name => "Message", :inverse_of => :replies

  belongs_to :sender, :class_name => "User", :inverse_of => :message_sent
  belongs_to :receiver, :class_name => "User", :inverse_of => :message_received

  validates_presence_of :from

  before_validation :set_from

  def set_from
    sender = User.find(self.sender_id)
    receiver = User.find(self.receiver_id)

    self.from ||= sender.username
    self.to ||= receiver.username
  rescue
    self.from ||= 'anonymous'
  end
end

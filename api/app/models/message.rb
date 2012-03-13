class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  # ---------------------------------------------------------------------------
  #
  # Relations
  # ---------------------------------------------------------------------------
  belongs_to :user, :foreign_key => :sender_id
  has_many :replies, :foreign_key => :topic_id, :class_name => "Message", :dependent => :destroy
  
  # ---------------------------------------------------------------------------
  #
  # FIELD
  # ---------------------------------------------------------------------------
  #
  # -- Account Information
  field :sender_id
  field :recipient_id
  field :topic_id
  field :message
  field :sent_at
  
  # ---------------------------------------------------------------------------
  #
  # Validation
  # ---------------------------------------------------------------------------
  #
  # -- Presence
  validates_presence_of :message
  validates_presence_of :recipient_id
  validates_presence_of :sender_id
  #
  # SCOPES
  # CALLBACKS

end

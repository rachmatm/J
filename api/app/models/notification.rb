class Notification
  include Mongoid::Document

  # ---------------------------------------------------------------------------
  #
  # Relations
  # ---------------------------------------------------------------------------
  belongs_to :user

  field :authors, :type => Array, :default => []
  field :summary, :type => String
  field :time, :type => DateTime
  field :content, :type => String
  field :jot_id, :type => String
  field :type, :type => String
  field :read, :type => Boolean, :default => false

  validates_presence_of :summary, :time
end

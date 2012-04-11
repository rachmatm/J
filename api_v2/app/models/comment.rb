class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIVATE_FIELDS = []

  PROTECTED_FIELDS = []

  PUBLIC_FIELD = [:message]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = [:user]

  RELATION_PUBLIC_DETAIL = []

  field :message, :type => String

  validates_presence_of :message
  validates_presence_of :jot
  validates_presence_of :user

  belongs_to :jot
  belongs_to :user

  scope :page, ->(page, per_page) { skip(per_page.to_i * (page.to_i - 1)).limit(per_page.to_i)}
  scope :order_by_default, order_by([[:updated_at, :desc]])
  scope :before_the_time, ->(timestamp, per_page) { where(:updated_at.lt => timestamp).limit(per_page.to_i)}
end
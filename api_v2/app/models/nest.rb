class Nest
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIVATE_FIELDS = []

  PROTECTED_FIELDS = []

  PUBLIC_FIELD = [:name]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = []

  RELATION_PUBLIC_DETAIL = []

  field :name, :type => String
  
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :name

  scope :page, ->(page, per_page) { skip(per_page.to_i * (page.to_i - 1)).limit(per_page.to_i)}
  scope :order_by_default, order_by([[:updated_at, :desc]])
end
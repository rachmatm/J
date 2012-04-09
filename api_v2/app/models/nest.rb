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
  has_many :nest_items

  validates_presence_of :user
  validates_presence_of :name

  scope :page, ->(page, per_page) { skip(per_page.to_i * (page.to_i - 1)).limit(per_page.to_i)}
  scope :order_by_default, order_by([[:updated_at, :desc]])

  def self.get_item(nest_id)
    data =  self.find nest_id

    JsonizeHelper.format({:content => data}, {:except => NestItem::NON_PUBLIC_FIELDS, :include => NestItem::RELATION_PUBLIC})
  rescue
    JsonizeHelper.format :failed => true, :error => "Nest was not found"
  end
end
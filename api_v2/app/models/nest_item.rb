class NestItem
  include Mongoid::Document
  include Mongoid::Timestamps
  PRIVATE_FIELDS = []

  PROTECTED_FIELDS = [:nest_id]

  PUBLIC_FIELD = [:name, :tags]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = []

  RELATION_PUBLIC_DETAIL = []

  field :name, :type => String

  belongs_to :nest
  has_and_belongs_to_many :tags

  validates_presence_of :nest
  validates_presence_of :name
end
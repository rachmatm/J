class Tag
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

  key :name

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false

  has_and_belongs_to_many :users
  has_and_belongs_to_many :jots

  before_create :lowerize_name

  protected

  def lowerize_name
    self.name = self.name.downcase
  end
end
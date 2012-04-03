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
  field :meta_weight, :type => Integer, :default => 0
  field :meta_thumbups, :type => Integer, :default => 0
  field :meta_thumbdowns, :type => Integer, :default => 0
  field :meta_comments, :type => Integer, :default => 0
  field :meta_subscriptions, :type => Integer, :default => 0
  field :meta_favorites, :type => Integer, :default => 0

  key :name

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false

  has_and_belongs_to_many :users
  has_and_belongs_to_many :jots

  before_create :lowerize_name
  before_save :set_tag_metadata

  protected

  def lowerize_name
    self.name = self.name.downcase
  end

  def set_tag_metadata
    self.meta_subscriptions = self.user_ids.uniq.count
    self.meta_weight = self.jot_ids.count
  end
end
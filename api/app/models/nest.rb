class Nest
  include Mongoid::Document
  include Mongoid::Timestamps

  # -- Relation
  has_and_belongs_to_many :tags
  accepts_nested_attributes_for :tags
  belongs_to :user

  # -- Fields
  field :name, :type => String


  # -- validates
  validates_presence_of :name, :tag_ids

  # -- Callbacks
  before_validation :validate_tags

  scope :page, ->(page, per_page) { skip(per_page.to_i * (page.to_i - 1)).limit(per_page.to_i)}
  scope :order, order_by([[:created_at, :desc]])


  def validate_tags
    self.tag_ids.each_with_index do | tag, index |
      if self.tag_ids[index + 1].present? and
          Tag.find(tag.to_s.downcase).tag_tags.where(:name => self.tag_ids[index + 1].to_s.downcase).count == 0
        
        self.errors.add :tags, 'Invalid Tag hierarchy'
        break
      end
    end
  end
end
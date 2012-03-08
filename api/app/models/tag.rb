class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  #-- Relation
  has_and_belongs_to_many :jots
  has_and_belongs_to_many :users
  has_and_belongs_to_many :tag_tags, :class_name => 'Tag'
  
  #-- Fields
  field :name, :type => String

  # Metadata
  # Weight: How many times a tag has been used
  # Thumb-ups: How many thumb ups for Jots using this tag
  # Dislike: How many thumb downs for Jots using this tag
  # Comments: How many comments for Jots using this tag
  # Subscriptions: How many users are subscribing to the tag
  # Subscribers: Who is subscribing to the tag
  # Favorites: How many users have favorited jots using this tag
  # Users: Who has used this tag
  field :meta, :type => Hash, :default => {'weight' => 0, 'thumb_ups' => 0,'dislike' => 0,
    'comments' => 0, 'subscriptions' => 0, 'favorites' => 0, 'user_ids' => []}


  #-- Model Property
  key :name

  #-- Validation
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false

  #-- Callbacks
  before_create :before_create_set_name

  scope :page, ->(page, per_page) { skip(per_page.to_i * (page.to_i - 1)).limit(per_page.to_i)}
  scope :order, order_by([[:name, :asc]]) 

  def _current_tag_set_meta(meta = {})
    _current_tag_load_meta meta
    self.save
  end

  def _current_tag_load_meta(meta = {})
    self.meta = self.meta.merge(meta || {})
  end

  def _current_tag_set_meta_subcription(user_id)
    unless self.meta['user_ids'].include? user_id
      _current_tag_set_meta 'subscriptions' => self.meta['subscriptions'].to_i + 1, 'user_ids' => self.meta['user_ids'] + [user_id]
    end
  end

  def _current_tag_unset_meta_subcription(user_id)
    if self.meta['user_ids'].include? user_id
      _current_tag_set_meta 'subscriptions' => self.meta['subscriptions'].to_i - 1, 'user_ids' => self.meta['user_ids'].delete(user_id)
    end
  end
  
  protected
  def before_create_set_name
    self.name = self.name.downcase
  end
end
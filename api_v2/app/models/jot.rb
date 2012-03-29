class Jot
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIVATE_FIELDS = []

  PROTECTED_FIELDS = []

  PUBLIC_FIELD = [:title]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = [:user, :tags, :user_thumbsup, :user_mentioned, :user_thumbsdown, :user_favorites]

  RELATION_PUBLIC_DETAIL = []

  field :title, :type => String

  validates_presence_of :title
  validates_length_of :title, :maximum => 140

  belongs_to :user
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :user_favorites, :class_name => "User", :inverse_of => :jot_favorites
  has_and_belongs_to_many :user_thumbsup, :class_name => "User", :inverse_of => :jot_thumbsup
  has_and_belongs_to_many :user_thumbsdown, :class_name => "User", :inverse_of => :jot_thumbsdown
  has_and_belongs_to_many :rejots, :class_name => "Jot"
  has_and_belongs_to_many :user_mentioned, :class_name => "User", :inverse_of => :jot_mentioned

  scope :page, ->(page, per_page) { skip(per_page.to_i * (page.to_i - 1)).limit(per_page.to_i)}
  scope :order_by_default, order_by([[:updated_at, :desc]])
  scope :before_the_time, ->(timestamp, per_page) { where(:updated_at.lt => timestamp).limit(per_page.to_i)}
  scope :find_by_user_tags, ->(user) {any_of({"tag_ids" => {"$in" => user.tags.collect{|tag| tag.id}}}, {'user_id' => user.id})}

  def current_jot_set_mention_users
    self.save

    Twitter::Extractor.extract_mentioned_screen_names(self.title).each do |username|
      user = User.where(:username => /#{username}/i).first

      if user.present?
         self.user_mentioned.push user
      end
    end

    self.reload
  end
end
class Jot
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIVATE_FIELDS = []

  PROTECTED_FIELDS = []

  PUBLIC_FIELD = [:title, :detail]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = [:user, :tags, :user_thumbsup, :user_mentioned, :user_thumbsdown, :user_favorites]

  RELATION_PUBLIC_DETAIL = []

  attr_accessor :user_thumbups_count

  field :title, :type => String
  field :detail, :type => String, :default => ""
  field :facebook_id, :type => String
  field :twitter_id, :type => String

  validates_presence_of :title
  validates_length_of :title, :maximum => 140

  belongs_to :user
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :user_favorites, :class_name => "User", :inverse_of => :jot_favorites
  has_and_belongs_to_many :user_thumbsup, :class_name => "User", :inverse_of => :jot_thumbsup
  has_and_belongs_to_many :user_thumbsdown, :class_name => "User", :inverse_of => :jot_thumbsdown
  has_and_belongs_to_many :rejots, :class_name => "Jot"
  has_and_belongs_to_many :user_mentioned, :class_name => "User", :inverse_of => :jot_mentioned
  has_many :comments

  scope :page, ->(page, per_page) { skip(per_page.to_i * (page.to_i - 1)).limit(per_page.to_i)}
  scope :order_by_default, order_by([[:updated_at, :desc]])
  scope :before_the_time, ->(timestamp, per_page) { where(:updated_at.lt => timestamp).limit(per_page.to_i)}
  scope :find_by_user_tags, ->(user) {any_of({"tag_ids" => {"$in" => user.tags.collect{|tag| tag.id}}}, {'user_id' => user.id})}

  after_create :current_jot_set_crosspost
  after_save :current_jot_set_tags, :current_jot_set_mention_users

  def self.get_comments(jot_id, options = {})
    jot = self.find jot_id

    if options[:timestamp] == 'now' or not options[:timestamp].present?
      params_timestamp = Time.now();
    elsif options[:timestamp].present?
      params_timestamp = Time.iso8601(options[:timestamp])
    end

    data = jot.comments.before_the_time(params_timestamp, options[:per_page]).order_by_default
    data_total = jot.comments.length

    JsonizeHelper.format({:content => data, :query => {:total => data_total}}, {:except => Comment::NON_PUBLIC_FIELDS, :include => Comment::RELATION_PUBLIC})
  rescue
    JsonizeHelper.format :failed => true, :error => 'Jot not found'
  end

  protected

  def current_jot_set_crosspost
    self.user.connections.where(:permission => 'always').each do |conn|
      if conn.provider == 'facebook'
        current_jot_set_crosspost_facebook conn, self
      elsif conn.provider == 'twitter'
        current_jot_set_crosspost_twitter conn, self
      end
    end

    if m = /F\/(\S*)\//.match(self.title) and 
        conn = self.user.connections.where(:permission => 'allow', :provider_user_name => m[1].downcase, :provider => 'facebook').first

      current_jot_set_crosspost_facebook conn, self
    end

    if m = /T\/(\S*)\//.match(self.title) and
        conn = self.user.connections.where(:permission => 'allow', :provider_user_name => m[1].downcase, :provider => 'twitter').first

      current_jot_set_crosspost_twitter conn, self
    end
  end

  def current_jot_set_crosspost_facebook(conn, jot)

    t = Thread.new do
      begin
        fc = FacebookConnect.new conn.provider_user_id, conn.provider_user_token
        result = fc.publish('wall', {:message => jot.title})

        unless result['error'].present?
          current_jot = Jot.find self.id
          current_jot.update_attribute 'facebook_id', result['id']
        else
          conn.destroy
        end
      rescue
        conn.destroy
      end
    end
    t.join
  end

  def current_jot_set_crosspost_twitter(conn, jot)

    t = Thread.new do      
      begin
        client = Twitter::Client.new :oauth_token => conn.provider_user_token, :oauth_token_secret => conn.provider_user_secret
        result = client.update jot.title

        current_jot = Jot.find self.id
        current_jot.update_attribute 'twitter_id', result['id']
      rescue
        conn.destroy
      end
    end
    t.join
  end

  def current_jot_set_tags
    assingned_tags = []
    
    Twitter::Extractor.extract_hashtags(self.title).uniq.each do |tag|

      assingned_tags << data_tag = Tag.find_or_create_by({:name => tag.downcase})
      
      self.tags.push data_tag
      self.user.tags.push data_tag
    end

    self.reload
    
    assingned_tags.each do | assingned_tag |
      assingned_tag.tag_similiarities.concat assingned_tags.reject{|t| t == assingned_tag}
    end
  end

  def current_jot_set_mention_users
    Twitter::Extractor.extract_mentioned_screen_names(self.title).each do |username|
      user = User.where(:username => /#{username}/i).first

      if user.present?
        self.user_mentioned.push user
      end
    end

    self.reload
  end
end
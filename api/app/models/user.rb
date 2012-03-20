require 'carrierwave/mongoid'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # ---------------------------------------------------------------------------
  #
  # Relations
  # ---------------------------------------------------------------------------
  #
  # -- Tag
  has_and_belongs_to_many :tags
  #
  # -- Jot
  has_many :jots
  
  # -- Private Message
  has_many :messages, :foreign_key => :sender_id


  # -- Nest
  has_many :nests

  accepts_nested_attributes_for :jots

  #has_many :favorites
  #has_many :kudos
  has_many :nests
  has_and_belongs_to_many :jot_favorites, :class_name => "Jot", :inverse_of => :user_favorites
  has_and_belongs_to_many :jot_thumbs_up, :class_name => "Jot", :inverse_of => :user_thumbs_up
  has_and_belongs_to_many :jot_thumbs_down, :class_name => "Jot", :inverse_of => :user_thumbs_down

  # Mounting the carrierwave methods into the 'avatar' column on
  mount_uploader :avatar, AvatarUploader, :mount_on => :avatar
  mount_uploader :avatar_facebook, AvatarUploader, :mount_on => :avatar_facebook
  mount_uploader :avatar_twitter, AvatarUploader, :mount_on => :avatar_twitter
  has_and_belongs_to_many :attachments
  accepts_nested_attributes_for :attachments
  
  # ---------------------------------------------------------------------------
  #
  # FIELD
  # ---------------------------------------------------------------------------
  #
  # -- Account Information
  field :username, :type => String
  field :realname, :type => String
  field :bio, :type => String
  field :url, :type => String
  field :email, :type => String
  field :latitude, :type => String
  field :longitude, :type => String
  field :location, :type => String
  #
  # -- Avatar
  field :avatar, :type => String
  #
  # -- Avatar Facebook
  field :avatar_facebook, :type => String
  field :avatar_facebook_square, :type => String
  field :avatar_facebook_large, :type => String
  #
  # -- Avatar Twitter
  field :avatar_twitter, :type => String
  field :avatar_twitter_normal, :type => String
  field :avatar_twitter_default, :type => String
  #
  # -- Avatar Properties
  field :avatar_selected, :type => String, :default => "jotky"
  field :avatar_coord_x, :type => Integer, :default => 0
  field :avatar_coord_y, :type => Integer, :default => 0
  field :avatar_coord_w, :type => Integer, :default => 400
  field :avatar_coord_h, :type => Integer, :default => 400
  # -- Account Settings - Privacy
  field :jots_privacy, :type => String, :default => "everyone"
  field :show_location_privacy, :type => String, :default => "everyone"
  field :show_kudos_privacy, :type => String, :default => "everyone"
  #
  # -- Account Settings - Your Stream
  field :hot_stream_home_page, :type => String, :default => "yes"
  field :show_anonymous_jots, :type => String, :default => "yes"
  #
  # -- Account Settings - Default Post
  field :auto_shorten_url, :type => String, :default => "always"
  field :auto_complete, :type => String, :default => "always"

  #
  # -- Account Settings - Connections Facebook
  field :facebook_connection, :type => String, :default => "allow"
  field :facebook_always_cross_post, :type => Boolean, :default => true
  #
  # -- Account Settings - Connections Twitter
  field :twitter_connection, :type => String, :default => "allow"
  field :twitter_always_cross_post, :type => Boolean, :default => true
  #
  # -- Account Settings - Media Upload
  field :upload_videos_to_facebook, :type => Boolean, :default => false
  field :upload_videos_to_youtube, :type => Boolean, :default => false
  field :upload_pictures_to_facebook, :type => Boolean, :default => false
  #
  # -- Facebook
  field :facebook_id, :type => String
  field :facebook_token, :type => String
  #
  # -- Twitter
  field :twitter_id, :type => String
  field :twitter_user_token, :type => String
  field :twitter_user_secret, :type => String

  # -- Google
  field :google_user_youtube_id, :type => String
  field :google_user_token, :type => String
  field :google_user_refresh_token, :type => String
  field :google_user_token_expires_at, :type => DateTime

  # ---------------------------------------------------------------------------
  #
  # Model Property
  # ---------------------------------------------------------------------------
  key :username

  # ---------------------------------------------------------------------------
  #
  # Validation
  # ---------------------------------------------------------------------------
  # 
  # -- Presence
  validates_presence_of :realname, :username
  #
  # -- Format
  validates_format_of :username, :with => /^[A-Za-z\d_]+$/, :message => "can only be alphanumeric with no spaces"
  validates_format_of :url, :with => URI::regexp(%w(http https)), :allow_nil => true
  #
  # -- Length
  validates_length_of :username, :minimum => 5
  validates_length_of :bio, :maximum => 512
  #
  # -- Uniqueness
  validates_uniqueness_of :username, :email, :case_sensitive => false
  #
  # -- CarrierWave
  validates_integrity_of :avatar
  validates_processing_of :avatar
  validates :avatar, :file_size => { :maximum => 4.megabytes.to_i }
  validates_integrity_of :avatar_facebook
  validates_processing_of :avatar_facebook
  validates :avatar_facebook, :file_size => { :maximum => 4.megabytes.to_i }
  validates_integrity_of :avatar_twitter
  validates_processing_of :avatar_twitter
  validates :avatar_twitter, :file_size => { :maximum => 4.megabytes.to_i }
  #
  # -- Inclusion
  validates_inclusion_of :jots_privacy, :in => ["everyone", "friends", "hide"], :allow_nil => true
  validates_inclusion_of :show_location_privacy, :in => ["everyone", "friends", "hide"], :allow_nil => true
  validates_inclusion_of :show_kudos_privacy, :in => ["everyone", "friends", "hide"], :allow_nil => true
  validates_inclusion_of :hot_stream_home_page, :in => ["yes", "no"], :allow_nil => true
  validates_inclusion_of :show_anonymous_jots, :in => ["yes", "no"], :allow_nil => true
  validates_inclusion_of :auto_shorten_url, :in => ["always", "ask", "never"], :allow_nil => true
  validates_inclusion_of :auto_complete, :in => ["always", "ask", "never"], :allow_nil => true
  validates_inclusion_of :facebook_connection, :twitter_connection, :in => ["allow", "deny"], :allow_nil => true

  # -- User fields
  PRIVATE_FIELDS = [
    :avatar_selected,
    :password_hash,
    :password_salt]

  PROTECTED_FIELDS = [
    :jots_privacy,
    :show_location_privacy,
    :show_kudos_privacy,
    :hot_stream_home_page,
    :show_anonymous_jots,
    :auto_shorten_url,
    :auto_complete,
    :facebook_connection,
    :facebook_always_cross_post,
    :twitter_connection,
    :twitter_always_cross_post,
    :upload_videos_to_facebook,
    :upload_videos_to_youtube,
    :upload_pictures_to_facebook]

  PUBLIC_FIELD = [
    :username,
    :email,
    :realname,
    :bio,
    :url,
    :avatar,
    :avatar_selected,
    :avatar_coord_x,
    :avatar_coord_y,
    :avatar_coord_w,
    :avatar_coord_h,
    :selected_avatar,
    :avatar_facebook,
    :avatar_facebook,
    :avatar_facebook_square,
    :avatar_facebook_large,
    :avatar_twitter,
    :avatar_twitter,
    :avatar_twitter_normal,
    :avatar_twitter_default
  ]
  
  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  # -- User fields
  JOT_PRIVATE_FIELDS = Jot::PRIVATE_FIELDS

  JOT_PROTECTED_FIELDS = Jot::PROTECTED_FIELDS

  JOT_PUBLIC_FIELD = Jot::PUBLIC_FIELD

  JOT_NON_PUBLIC_FIELDS = JOT_PRIVATE_FIELDS + JOT_PROTECTED_FIELDS

  JOT_UPDATEABLE_FIELDS = JOT_PROTECTED_FIELDS + JOT_PUBLIC_FIELD

  JOT_RELATION_PUBLIC = Jot::RELATION_PUBLIC

  # -- Nest fields
  NEST_PRIVATE_FIELDS = []

  NEST_PROTECTED_FIELDS = []

  NEST_PUBLIC_FIELD = [
    :name,
    :tag_ids
  ]

  NEST_NON_PUBLIC_FIELDS = NEST_PRIVATE_FIELDS + NEST_PROTECTED_FIELDS

  NEST_UPDATEABLE_FIELDS = NEST_PROTECTED_FIELDS + NEST_PUBLIC_FIELD

  NEST_RELATION_PUBLIC = [
    :tags
  ]

  # -- Tag
  TAG_PRIVATE_FIELDS = []

  TAG_PROTECTED_FIELDS = []

  TAG_PUBLIC_FIELD = [
    :name
  ]

  TAG_NON_PUBLIC_FIELDS = TAG_PRIVATE_FIELDS + TAG_PROTECTED_FIELDS

  TAG_UPDATEABLE_FIELDS = TAG_PROTECTED_FIELDS + TAG_PUBLIC_FIELD

  TAG_RELATION_PUBLIC = []

  # ---------------------------------------------------------------------------
  #
  # SCOPES
  # ---------------------------------------------------------------------------
  #
  scope :page, ->(page, per_page) { skip(per_page.to_i * (page.to_i - 1)).limit(per_page.to_i)}
  scope :order, order_by([[:id, :asc], [:realname, :desc]])

  def self.get(options = {})
    if options[:id].present?
      users = self.find(options[:id])
    elsif options.is_a? Hash and options[:page].present? and options[:per_page].present?
      users = self.all.order.page(options[:page], options[:per_page])
    else
      users = self.all.order
    end

    JsonizeHelper.format({:content => users}, {:except => NON_PUBLIC_FIELDS})
  rescue
    JsonizeHelper.format(:failed => true, :error => 'user not found')
  end

  def get
    JsonizeHelper.format({:content => self}, {:except => PRIVATE_FIELDS})
  end

  def reset(parameters)
    parameters.keep_if {|key, value| UPDATEABLE_FIELDS.include? key }

    if self.update_attributes(parameters)
      return JsonizeHelper.format :notice => "Update succeed."
    else
      return JsonizeHelper.format :failed => true, :errors => self.errors.to_a.uniq, :error => "Update failed"
    end
  end

  # Relation: Jots
  def current_user_set_jot(parameters = {})
    parameters.keep_if {|key, value| JOT_UPDATEABLE_FIELDS.include? key }

    #set tags
    tag_names = Twitter::Extractor.extract_hashtags(parameters[:title])
    tag_objs = _current_user_set_tags(tag_names)

    #set attachment
    file_objs = _current_user_set_files(parameters[:attachments]) if parameters[:attachments].is_a? Array
    parameters.delete :attachments
    

    jot = self.jots.new parameters
    jot.tags = tag_objs
    jot.attachments = file_objs

    unless jot.save
      JsonizeHelper.format :failed => true, :error => "Jot was not made", :errors => jot.errors.to_a.uniq
    else
      JsonizeHelper.format({:notice => "Jot Successfully Made", :content => jot}, {
        :except => JOT_NON_PUBLIC_FIELDS,
        :include => JOT_RELATION_PUBLIC
      })
    end
  end

  def current_user_unset_jot(jot_id)
    if jot = self.jots.find(jot_id).destroy
      JsonizeHelper.format :content => jot, :notice => "Jot Successfully Deleted"
    else
      JsonizeHelper.format :content => jot, :error => "Jot is not successfully destroyed", :errors => jot.errors.to_a
    end
  rescue
    JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_get_jot(params = {})
    request_query = {:per_page => nil, :page => nil, :total_jot => nil, :total_page => nil }
    
    if params[:id].present?
      _jots =  self.jots.find params[:id]
      request_query.merge! :total_jot => 1
    elsif params[:per_page].present? and params[:page].present?
      _jots = Jot.find_by_user_tags(self).page(params[:page], params[:per_page]).order_by_default
      
      request_query.merge!({
          :per_page => params[:per_page].to_i,
          :page => params[:page].to_i,
          :total_jot => _jots.count,
          :total_page => (_jots.count / params[:per_page].to_f).ceil })

    elsif params[:timestamp] == 'now' and params[:per_page].present?
      params_timestamp = Time.now()
      
      _jots = Jot.find_by_user_tags(self).before_the_time(params_timestamp, params[:per_page] ).order_by_default
      
    elsif params[:timestamp] and params[:per_page].present?
      params_timestamp = Time.iso8601(params[:timestamp])
      
      _jots = Jot.find_by_user_tags(self).before_the_time(params_timestamp, params[:per_page]).order_by_default

    else
      _jots = Jot.any_of({"tag_ids" => {"$in" => self.tags.collect{|tag| tag.id}}}, {'user_id' => self.id}).order_by_default
      request_query.merge! :total_jot => _jots.count
    end

    JsonizeHelper.format({
        :content => _jots,
        :query => request_query
      },
      {
        :except => JOT_NON_PUBLIC_FIELDS, 
        :include => JOT_RELATION_PUBLIC
      })
  rescue
    JsonizeHelper.format :failed => true, :error => 'Jot not found'
  end

  def current_user_set_favorite_jot(jot_id)
    jot = Jot.find(jot_id)

    unless self.jot_favorites.include?(jot)
      self.jot_favorites << jot unless self.jot_favorites.include?(jot)
      JsonizeHelper.format :notice => "Jot is now in favorites"
    else
      self.jot_favorites.delete jot
      return JsonizeHelper.format :notice =>  "Jot is not in favorites anymore"
    end

  rescue
    return JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_set_thumbs_up_jot(jot_id)
    jot = Jot.find(jot_id)

    jot.user_thumbs_up.delete self
    
    jot.user_thumbs_up << self
    
    jot.user_thumbs_down.delete self

    JsonizeHelper.format :notice => "Jot was thumbed up",
      :total_thumbsup => jot.user_thumbs_up.length, :total_thumbsdown => jot.user_thumbs_down.length
  rescue
    JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_set_thumbs_down_jot(jot_id)
    jot = Jot.find(jot_id)

    jot.user_thumbs_down.delete self

    jot.user_thumbs_down << self

    jot.user_thumbs_up.delete self
    
    return JsonizeHelper.format :notice => "Jot was thumbed down",
      :total_thumbsup => jot.user_thumbs_up.length, :total_thumbsdown => jot.user_thumbs_down.length
  rescue
    return JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_get_favorite_jot
    if self.jot_favorites.any?
      JsonizeHelper.format :content => self.jot_favorites
    else
      JsonizeHelper.format :notice => "You don't have any favorite"
    end
  end

  def current_user_get_thumbs_up_jot
    if self.jot_thumbs_up.any?
      JsonizeHelper.format :content => self.jot_thumbs_up
    else
      JsonizeHelper.format :notice => "You don't have any Thumbs Up Jot"
    end
  end

  def current_user_get_thumbs_down_jot
    if self.jot_thumbs_down.any?
      return JsonizeHelper.format :content => self.jot_thumbs_down
    else
      return JsonizeHelper.format :notice => "You don't have any Thumbs Up Jot"
    end
  end

  # Relation: Tags
  def _current_user_set_tags(tag_names = [])

    raise 'Wrong Parameters' unless tag_names.is_a? Array

    tag_objs = Array.new

    tag_names.uniq.each do |tag_name|
      begin
        tag = self.tags.find tag_name.to_s.downcase
        tag._current_tag_set_meta_subcription self.id

        unless self.tag_ids.include? tag.id
          self.tag_ids.push(tag.id)
          self.save
        end
      rescue
        
        tag = self.tags.create :name => tag_name.to_s.downcase
        tag._current_tag_set_meta_subcription self.id
      ensure
        tag_objs << tag
      end
    end

    return tag_objs
  end

  def _current_user_unset_tags(tag_names = [])
    raise 'Wrong Parameters' unless tag_names.is_a? Array

    tag_names.each do |tag_name|
      tag = self.tags.where(:name => tag_name.to_s.downcase).first

      if tag.present?
        tag._current_tag_unset_meta_subcription self.id
        self.tag_ids.delete(tag.name)
      end
      
    end

    self.save
  end

  # Relation: Files
  def _current_user_set_files(files = [])
    raise 'User#_current_user_set_files Wrong Parameters' unless files.is_a? Array

    file_objs = Array.new

    files.each do |id, file|
      begin
        file_objs << self.attachments.push(File.find file[:id])
      rescue
        file_objs << self.attachments.create(:file => file['file'])
      end
    end

    return file_objs
  end

  def current_user_set_tags(tag_names = "")
    arr_tag_names = Twitter::Extractor.extract_hashtags(tag_names)
    _current_user_set_tags(arr_tag_names)
    JsonizeHelper.format :notice => "Successfully added tag"
  end

  def current_user_unset_tags(tag_names = "")
    arr_tag_names = Twitter::Extractor.extract_hashtags(tag_names)
    _current_user_unset_tags arr_tag_names
    JsonizeHelper.format :notice => "Successfully deleted"
  end

  def current_user_get_tags(params = {})
    request_query = {:per_page => nil, :page => nil, :total_tag => nil, :total_page => nil }
    
    if params[:per_page].present? and params[:page].present?
      _tags = self.tags.page(params[:page], params[:per_page]).order

      request_query.merge!({
          :per_page => params[:per_page].to_i,
          :page => params[:page].to_i,
          :total_tag => _tags.count,
          :total_page => (_tags.count / params[:per_page].to_f).ceil })

    else
      _tags = self.tags.all.order

      request_query.merge! :total_jot => _tags.count
    end

    JsonizeHelper.format({
        :content => _tags,
        :query => request_query
      },
      {
        :except => TAG_NON_PUBLIC_FIELDS,
        :include => TAG_RELATION_PUBLIC
      })
  end

  def current_user_set_nest(parameters = {})
    parameters.keep_if {|key, value| NEST_UPDATEABLE_FIELDS.include? key }
    nest = self.nests.create parameters

    if nest.errors.any?
      JsonizeHelper.format :error => "failed", :failed => true, :errors => nest.errors.to_a.uniq
    else
      JsonizeHelper.format :notice => "succeed"
    end
  end

  def current_user_unset_nest(nest_id)
    self.nests.find(nest_id).destroy

    JsonizeHelper.format :notice => "Successfully deleted"
  rescue
    JsonizeHelper.format :error => "Nest not found", :failed => true
  end

  def current_user_reset_nest(nest_id, parameters = {})
    parameters.keep_if {|key, value| NEST_UPDATEABLE_FIELDS.include? key }
    
    nest = self.nests.find nest_id
    nest.update_attributes parameters

    if nest.errors.any?
      JsonizeHelper.format :error => "failed", :failed => true, :errors => nest.errors.to_a.uniq
    else
      JsonizeHelper.format :notice => "succeed"
    end

  rescue
    JsonizeHelper.format :error => "Nest not found", :failed => true
  end

  def current_user_get_nest(params = {})
    request_query = {:per_page => nil, :page => nil, :total_nest => nil, :total_page => nil }

    if params[:id].present?
      _nests =  self.nests.find params[:id]
      request_query.merge! :total_nest => 1
    elsif params[:per_page].present? and params[:page].present?
      _nests = self.nests.page(params[:page], params[:per_page]).order

      request_query.merge!({
          :per_page => params[:per_page].to_i,
          :page => params[:page].to_i,
          :total_nest => _nests.count,
          :total_page => (_nests.count / params[:per_page].to_f).ceil  })

    else
      _nests = self.nests.all.order

      request_query.merge! :total_nest => _nests.count
    end

    JsonizeHelper.format({
        :content => _nests,
        :query => request_query
      },
      {
        :except => NEST_NON_PUBLIC_FIELDS,
        :include => NEST_RELATION_PUBLIC
      })
  rescue
    JsonizeHelper.format :failed => true, :error => 'Jot not found'
  end

  def update_avatar(parameters)
    parameters[:selected_avatar] ||= 'jotky'
    parameters[:avatar_coord_w] ||= 400
    parameters[:avatar_coord_h] ||= 400
    parameters[:avatar_coord_x] ||= 0
    parameters[:avatar_coord_y] ||= 0

    if parameters[:selected_avatar] == 'facebook'
      parameters[:remote_avatar_facebook_url] = self.facebook_avatar_large
    elsif parameters[:selected_avatar] == 'twitter'
      parameters[:remote_avatar_twitter_url] = self.facebook_twitter_large
    end

    if self.update_attributes parameters
      # Update Image
      if parameters[:avatar_coord_w] and parameters[:avatar_coord_h] and parameters[:avatar_coord_x] and parameters[:avatar_coord_y]
        self.update_attributes :avatar => File.open(self.avatar.path)
      end

      return JsonizeHelper.format :notice => "Avatar Uploaded.", :content => {:avatar => self.avatar}
    else
      return JsonizeHelper.format :failed => true, :error => "Avatar upload failed", :errors => self.errors.to_a.uniq
    end
  end

# Facebook
# ------------------------------------------------------------------------

  def current_user_get_facebook_wall
    get_facebook_wall_url = "https://graph.facebook.com/me/home"
    get_facebook_wall_response = ActiveSupport::JSON.decode Typhoeus::Request.get(get_facebook_wall_url, :params => {:access_token => self.facebook_token, :limit => 5}).body

    if get_facebook_wall_response != false
      return JsonizeHelper.format :content => get_facebook_wall_response
    else
      return JsonizeHelper.format :failed => true, :error => "Something went wrong, please try again"
    end
  end

  def current_user_set_facebook_status(message)
    post_facebook_status_url = "https://graph.facebook.com/me/feed"
    parameters = {:access_token => self.facebook_token, :message => message}
    post_facebook_status_response = ActiveSupport::JSON.decode Typhoeus::Request.post(post_facebook_status_url, :params => parameters ).body

    if post_facebook_status_response != false
      return JsonizeHelper.format :notice => "You have successfully update your status"
    else
      return JsonizeHelper.format :failed => true, :error => "Something went wrong, please try again"
    end
  end

# Twitter
# ------------------------------------------------------------------------

  def current_user_get_twitter_timeline
    get_twitter_timeline_url = "https://api.twitter.com/1/statuses/home_timeline.json"

    headers = { :oauth_consumer_key => TWITTER_CONSUMER_KEY,
      :oauth_nonce => ActiveSupport::SecureRandom.hex(16),
      :oauth_signature_method => "HMAC-SHA1",
      :oauth_timestamp => Time.now.to_i,
      :oauth_token => self.twitter_user_token,
      :oauth_version => "1.0"
    }

    signature_header = { :count => 5, :include_entities=> true }.merge headers
    oauth_signature = TwitterHelper.oauth_signature("get", get_twitter_timeline_url, self.twitter_user_secret, signature_header)

    headers.merge!( {:oauth_signature => oauth_signature} )

    headers = headers.sort.collect {|key, value| "#{key}=\"#{value}\"" }.join(', ')

    get_twitter_timeline_response = ActiveSupport::JSON.decode Typhoeus::Request.get(get_twitter_timeline_url,
                                                                                     :headers => { :Authorization => "OAuth #{headers}" },
                                                                                     :params => { :include_entities => true, :count => 5 }
                                                                                    ).body

    if get_twitter_timeline_response.is_a? Array or get_twitter_timeline_response['error'].present?
      return JsonizeHelper.format :content => get_twitter_timeline_response
    else
      return JsonizeHelper.format :failed => true, :error => "Something went wrong, please try again"
    end
  end

  def current_user_set_twitter_status(status)
    post_twitter_status_url = "https://api.twitter.com/1/statuses/update.json"

    headers = { :oauth_consumer_key => TWITTER_CONSUMER_KEY,
      :oauth_nonce => ActiveSupport::SecureRandom.hex(16),
      :oauth_signature_method => "HMAC-SHA1",
      :oauth_timestamp => Time.now.to_i,
      :oauth_token => self.twitter_user_token,
      :oauth_version => "1.0"
    }

    signature_header = headers.merge({ :status => ERB::Util::url_encode(status) })
    oauth_signature = TwitterHelper.oauth_signature("post", post_twitter_status_url, self.twitter_user_secret, signature_header)

    headers.merge!( {:oauth_signature => oauth_signature} )

    headers = headers.sort.collect {|key, value| "#{key}=\"#{value}\"" }.join(', ')

    post_twitter_status_response = ActiveSupport::JSON.decode Typhoeus::Request.post(post_twitter_status_url,
                                                                                     :headers => { :Authorization => "OAuth #{headers}" },
                                                                                     :params => { :status => CGI.escape(status) }
                                                                                    ).body

    if not post_twitter_status_response['error'].present?
      return JsonizeHelper.format :notice => "You have successfully update your status"
    else
      return JsonizeHelper.format :failed => true, :error => "Something went wrong, please try again"
    end
  end

  # Favorite

  # Thumbs

  protected
  def current_avatar
    if self.selected_avatar == 'facebook'
      self.facebook_avatar
    elsif self.selected_avatar == 'twitter'
      self.twitter_avatar
    else
      self.avatar
    end
  end
  
  #message
  def current_user_set_private_message(params = {})
    private_message = self.messages.create params
    if private_message.errors.any?
      return JsonizeHelper.format :failed => true, :error => "Private message was not sent", :errors => private_message.errors.to_a
    else
      return JsonizeHelper.format :content => private_message, :notice => "Private message Successfully Sent"
    end
  end

# Favorites
# ------------------------------------------------------------------------

  def current_user_set_favorite_jot(jot_id)
    jot = Jot.find(jot_id)

    if self.jot_favorites.include?(jot)
      self.jot_favorites.delete jot
      JsonizeHelper.format :notice =>  "Jot is not in favorites anymore"
    else
      self.jot_favorites << jot
      JsonizeHelper.format :notice => "Jot is now in favorites"
    end
  rescue
    JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_unset_private_message(id)
    private_message = Message.find(id)
    if private_message.destroy
      JsonizeHelper.format :content => "Message was sucessfully deleted"
    end
  rescue
    JsonizeHelper.format :failed => true, :error => "Failed to delete message"
  end

  def current_user_get_favorite_jot
    if self.jot_favorites.present?
      JsonizeHelper.format :content => self.jot_favorites
    else
      JsonizeHelper.format :failed => true, :error => "You don't have any favorite", :content => []
    end
  end

# Thumbs
# ------------------------------------------------------------------------

#  def current_user_set_thumbs_up_jot(jot_id)
#    jot = Jot.find(jot_id)
#    self.jot_thumbs_down.delete jot if self.jot_thumbs_down_ids.include?(jot.id)
#    self.jot_thumbs_up << jot unless self.jot_thumbs_up_ids.include?(jot.id)
#    JsonizeHelper.format :notice => "Jot was thumbed up", :count => "The thumbs up now is #{jot.user_thumbs_up.count} and thumbs down is #{jot.user_thumbs_down.count}"
#  rescue
#    JsonizeHelper.format :failed => true, :error => "Jot was not found"
#  end

#  def current_user_set_thumbs_down_jot(jot_id)
#    jot = Jot.find(jot_id)
#    self.jot_thumbs_up.delete jot if self.jot_thumbs_up_ids.include?(jot.id)
#    self.jot_thumbs_down << jot unless self.jot_thumbs_down_ids.include?(jot.id)
#    JsonizeHelper.format :notice => "Jot was thumbed down", :count => "The thumbs up now is #{jot.user_thumbs_up.count} and thumbs down is #{jot.user_thumbs_down.count}"
#  rescue
#    JsonizeHelper.format :failed => true, :error => "Jot was not found"
#  end

  def current_user_get_thumbs_up_jot(jot_id)
    jot = Jot.find(jot_id)
    JsonizeHelper.format :content => jot.user_thumbs_up.count
  rescue
    JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_get_thumbs_down_jot(jot_id)
    jot = Jot.find(jot_id)
    JsonizeHelper.format :content => jot.user_thumbs_down.count
  rescue
    JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

# Nest
# ------------------------------------------------------------------------

  def current_user_set_nest(params)
    params[:tags] = params[:tags].collect { |tag| Tag.find_or_create_by :name => tag } unless params[:tags].nil?
    nest = self.nests.create params

    if nest.errors.any?
      JsonizeHelper.format :failed => true, :error => "Nest was not made, please try again", :errors => nest.errors.to_a
    else
      JsonizeHelper.format :notice => "Nest was successfully made"
    end
  end

  def current_user_unset_nest(nest_id)
    self.nests.find(nest_id).destroy
    JsonizeHelper.format :notice => "Nest was deleted successfully"
  rescue
    JsonizeHelper.format :failed => true, :error => "Nest mentioned was not found"
  end

  def current_user_reset_nest(params, nest_id)
    params[:name] ||= ""
    params[:tags] = params[:tags].collect { |tag| Tag.find_or_create_by :name => tag } unless params[:tags].nil?
    current_nest = self.nests.find(nest_id)

    if current_nest.update_attributes params
      JsonizeHelper.format :notice => "Nest was updated successfully"
    else
      JsonizeHelper.format :failed => true, :error => "Nest was not updated successfully", :errors => current_nest.errors.to_a
    end
  rescue
    JsonizeHelper.format :failed => true, :error => "Nest mentioned was not found"
  end

  def current_user_get_nest
    JsonizeHelper.format :content => self.nests
  end

  def current_user_get_single_nest(nest_id)
    current_nest = self.nests.find(nest_id)
    JsonizeHelper.format :content => current_nest
  rescue
    JsonizeHelper.format :failed => true, :error => "Nest mentioned was not found"
  end
  
  def current_user_get_private_message(params={})
    user_id = self.id
    private_messages = Message.where(topic_id: nil).any_of({ sender_id: "#{user_id}" }, { recipient_id: "#{user_id}" })
    if private_messages.present?
      return JsonizeHelper.format :content => private_messages.all
    else
      return JsonizeHelper.format :failed => true, :error => "There is No Message"
    end
  rescue
    return JsonizeHelper.format :failed => true, :error => "Failed to retrive message"
  end
  
  def current_user_show_private_message(params={})
    user_id = self.id
    message_id = params[:id]
    message_array = []
    private_message = Message.any_of({ sender_id: "#{user_id}" }, { recipient_id: "#{user_id}" }).find(message_id)
    message_array << private_message
    message_array << private_message.replies
    message_array.flatten
    return JsonizeHelper.format :content => message_array
  rescue
    return JsonizeHelper.format :failed => true, :error => "Failed to retrieve message"
  end
end

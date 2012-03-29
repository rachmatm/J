require 'carrierwave/mongoid'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # ---------------------------------------------------------------------------
  #
  # Relations
  # ---------------------------------------------------------------------------
  has_and_belongs_to_many :tags
  has_many :jots
  has_many :messages, :foreign_key => :sender_id
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
  has_many :attachments
  accepts_nested_attributes_for :attachments

  has_many :comments

  has_many :notifications

  has_and_belongs_to_many :jot_rejoters, :class_name => 'Jot', :inverse_of => :user_rejoters
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
  field :facebook_username, :type => String
  #
  # -- Twitter
  field :twitter_id, :type => String
  field :twitter_user_token, :type => String
  field :twitter_user_secret, :type => String
  field :twitter_user_username, :type => String

  # -- Google
  field :google_user_youtube_id, :type => String
  field :google_user_token, :type => String
  field :google_user_refresh_token, :type => String
  field :google_user_token_expires_at, :type => DateTime
  field :google_user_username, :type => String

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
  validates_inclusion_of :facebook_connection, :twitter_connection, :in => ["allow", "deny", "always"], :allow_nil => true

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

  RELATION_PUBLIC = [
    :jot_favorites
  ]

  # -- User fields
  #JOT_PRIVATE_FIELDS = Jot::PRIVATE_FIELDS
  JOT_PRIVATE_FIELDS = []

  #JOT_PROTECTED_FIELDS = Jot::PROTECTED_FIELDS
  JOT_PROTECTED_FIELDS = []

  #JOT_PUBLIC_FIELD = Jot::PUBLIC_FIELD
  JOT_PUBLIC_FIELD = [
    :title,
    :detail,
    :attachments,
    :location_latitude,
    :location_longitude,
    :location,
    :locations_attributes
  ]

  JOT_NON_PUBLIC_FIELDS = JOT_PRIVATE_FIELDS + JOT_PROTECTED_FIELDS

  JOT_UPDATEABLE_FIELDS = JOT_PROTECTED_FIELDS + JOT_PUBLIC_FIELD

  #JOT_RELATION_PUBLIC = Jot::RELATION_PUBLIC
  JOT_RELATION_PUBLIC = [
    :attachments,
    :tags,
    :user,
    :locations
  ]

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

    JsonizeHelper.format({:content => users}, {:except => NON_PUBLIC_FIELDS, :include => RELATION_PUBLIC})
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

  def search(text)
    stripped_text = text[1..-1]
    search_result = ActiveSupport::JSON.encode User.where(:username => /#{stripped_text}/i).only(:username)

    JsonizeHelper.format :content => search_result
  end

  def _current_user_set_locations(parameters)
    parameters_location = []

    parameters.to_a.each do | location |
      parameters_location.push location[1]
    end
    
    parameters = parameters_location

    Location.find Mongoid.master['locations'].insert(parameters)
  rescue
    []
  end

  def _current_user_set_attachments(parameters)
    parameters_location = []

    parameters.to_a.each do | location |
      parameters_location.push location[1]
    end

    parameters = parameters_location

    Attachment.find Mongoid.master['attachments'].insert(parameters)
  rescue
    []
  end

  # Relation: Jots
  def current_user_set_jot(parameters = {})
    parameters.keep_if {|key, value| Jot::UPDATEABLE_FIELDS.include? key }

    jot = self.jots.new parameters
    
    #set tags
    tag_names = Twitter::Extractor.extract_hashtags(parameters[:title])
    tag_objs = _current_user_set_tags(parameters[:title])
    jot.tags = tag_objs
    
    #set cross-post upload
    #file = parameters[:attachments]
    #parameters.delete :attachments
    #    attachments = []
    #

    # Facebook video upload
    #    if self.facebook_token.present? and self.upload_videos_to_facebook and ( file.present? and not file[:type].include? 'image' )
    #      facebook_uploader = AttachmentUploader.new
    #      facebook_uploader.store! file
    #
    #      facebook_upload_video_request = FacebookHelper.upload_video(parameters[:title], parameters[:description], facebook_uploader, self.facebook_token)
    #
    #      facebook_uploader.remove! if facebook_uploader.present?
    #      facebook_upload_video = Attachment.set(facebook_upload_video_request.response.body, 'facebook', self.facebook_token)
    #      attachments << facebook_upload_video
    #    end

    #    # Facebook photo upload
    #    if self.facebook_token.present? and self.upload_pictures_to_facebook and ( file.present? and file[:type].include? 'image' )
    #      facebook_upload_photo_request = FacebookHelper.upload_photo(parameters[:description], file[:tempfile], self.facebook_token)
    #    end

    #    # Youtube video upload
    #    if self.google_user_youtube_id.present? and self.upload_videos_to_youtube and ( file.present? and not file[:type].include? 'image' )
    #
    #      youtube_upload_response = GoogleHelper.upload_video(self.google_user_token,
    #        self.google_user_refresh_token,
    #        self.google_user_token_expires_at,
    #        parameters[:title],
    #        parameters[:description],
    #        file[:tempfile])
    #
    #      attachments << Attachment.set(youtube_upload_response, 'youtube')
    #    end

    #    attachments.each do |attachment|
    #      self.attachment_ids << attachment.id
    #      jot.attachment_ids << attachment.id
    #    end

    # Saving attachment in user
    #    self.save
    
    unless jot.save
      return JsonizeHelper.format :failed => true, :error => "Jot was not made", :errors => jot.errors.to_a.uniq
    else

      #set location
      location_objs = _current_user_set_locations(parameters[:locations])
      jot.locations.concat(location_objs)

      #set attachment
      attachments_objs = _current_user_set_attachments(parameters[:attachments])
      jot.attachments.concat(attachments_objs)

      jot.reload

      #self.current_user_set_facebook_status parameters[:title] if self.facebook_always_cross_post and
      #not facebook_upload_video_request.present? and not facebook_upload_photo_request.present?

      #self.current_user_set_twitter_status parameters[:title] if self.twitter_always_cross_post

       
      return JsonizeHelper.format({:notice => "Jot Successfully Made", :content => jot}, {
          :except => Jot::NON_PUBLIC_FIELDS,
          :include => Jot::RELATION_PUBLIC
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
        :except => Jot::NON_PUBLIC_FIELDS,
        :include => Jot::RELATION_PUBLIC
      })
  rescue
    JsonizeHelper.format :failed => true, :error => 'Jot not found'
  end

  def current_user_set_favorite_jot(jot_id)
    jot = Jot.find(jot_id)

    unless self.jot_favorites.include?(jot)
      self.jot_favorites.push jot
      JsonizeHelper.format :notice => "Jot is now in favorites", :faved => true
    else
      self.jot_favorites.delete jot
      return JsonizeHelper.format :notice =>  "Jot is not in favorites anymore", :faved => false
    end

  rescue
    return JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_set_rejot(jot_id)
    jot = Jot.find jot_id
    xjot = jot.clone
    xjot.save
    xjot.user_rejoters.concat([self])
    xjot.reload

    JsonizeHelper.format({
        :content => xjot
      },
      {
        :except => Jot::NON_PUBLIC_FIELDS,
        :include => Jot::RELATION_PUBLIC
      })
  rescue
    return JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_set_thumbs_up_jot(jot_id)
    jot = Jot.find(jot_id)

    jot.user_thumbs_up.delete self

    jot.user_thumbs_up.push self

    jot.user_thumbs_down.delete self

    JsonizeHelper.format :notice => "Jot was thumbed up",
      :total_thumbsup => jot.user_thumbs_up.length, :total_thumbsdown => jot.user_thumbs_down.length
  rescue
    JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_set_thumbs_down_jot(jot_id)
    jot = Jot.find(jot_id)

    jot.user_thumbs_down.delete self

    jot.user_thumbs_down.push self

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

  def current_user_set_jot_comment(jot_id, parameters = {})
    parameters.keep_if {|key, value| Comment::UPDATEABLE_FIELDS.include? key }

    data = self.comments.new parameters.merge(:jot_id => jot_id)

    if data.save
      JsonizeHelper.format({:notice => "Jot's Comment Successfully Made", :content => data}, {
          :except => Comment::NON_PUBLIC_FIELDS,
          :include => Comment::RELATION_PUBLIC
        })
    else
      JsonizeHelper.format :failed => true, :error => "Jot's Comment was not made", :errors => data.errors.to_a.uniq
    end
  rescue Exception => msg
    JsonizeHelper.format :failed => true, :error => msg
  end

  # Relation: Tags
  def _current_user_set_tags(text)
    tag_arr = Twitter::Extractor.extract_hashtags(text)

    tag_objs = Array.new

    tag_arr.uniq.each do |tag_name|
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
        tag_objs.push tag
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

  def current_user_search_tags(text)
    search_result = ActiveSupport::JSON.encode Tag.desc('meta.weight').where(:name => /#{text}/i)

    JsonizeHelper.format :content => search_result
  end

  # Relation: Files
  def _current_user_set_files(files = [])
    raise 'User#_current_user_set_files Wrong Parameters' unless files.is_a? Array

    file_objs = Array.new

    files.each do |id, file|
      begin
        file_objs.push self.attachments.push(File.find file[:id])
      rescue
        file_objs.push self.attachments.create(:file => file['file'])
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

  # Notifications
  # ------------------------------------------------------------------------

  def current_user_get_notifications
    return JsonizeHelper.format :content => self.notifications
  end

  def current_user_unset_notifications(notification_id, type = 'none')
    if notification_id != 'all'
      self.notifications.find(notification_id).destroy
    else
      self.notifications.where(:type => type).destroy
    end

    JsonizeHelper.format :notice => "Successfully deleted"
  rescue
    JsonizeHelper.format :error => "Notifications not found", :failed => true
  end

  # Facebook
  # ------------------------------------------------------------------------

  def current_user_add_facebook_account(code)
    parameter = { :client_id => FB_APP_ID, :redirect_uri => "http://localhost:3000/me/facebook/authenticate_account", :client_secret => FB_SECRET_KEY, :code => code }
    facebook_token_response = Typhoeus::Request.get("https://graph.facebook.com/oauth/access_token", :params => parameter).body

    if facebook_token_response.empty? or facebook_token_response['error'].present?
      return "http://localhost:5000/omniauth/authenticate_facebook?error=Something%20went%20wrong,%20Please%20try%20again."
    else
      facebook_token = facebook_token_response.gsub(/access_token=([^&]+)&?.*/, '\1')
      facebook_access_profile_response = Typhoeus::Request.get("https://graph.facebook.com/me", :params => {:access_token => facebook_token}).body
      profile = ActiveSupport::JSON.decode facebook_access_profile_response
      jotky_token = ActiveSupport::SecureRandom.hex(9)

      parameters = {:token => jotky_token, :facebook_username => profile['username'], :facebook_token => facebook_token, :realname => profile['name'], :facebook_id => profile['id']}

      Authentication.find(self.id).update_attributes parameters
      return "http://localhost:5000/omniauth/authenticate_facebook?facebook_token=#{facebook_token}&jotky_token=#{jotky_token}"
    end
  end

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

    post_facebook_status_request = Typhoeus::Request.new(post_facebook_status_url, :method => :post, :params => parameters )

    hydra = Typhoeus::Hydra.new
    hydra.queue(post_facebook_status_request)
    hydra.run

    post_facebook_status_response = ActiveSupport::JSON.decode post_facebook_status_request.response.body

    if post_facebook_status_response != false
      post_facebook_status_response
    else
      "Something went wrong, please try again"
    end
  end

  # Twitter
  # ------------------------------------------------------------------------

  def current_user_add_twitter_account(params)
    jotky_token = ActiveSupport::SecureRandom.hex(9)
    parameters = {:token => jotky_token,
      :twitter_user_token => params[:oauth_token],
      :twitter_user_secret => params[:oauth_secret],
      :twitter_user_username => params[:username],
      :realname => params[:realname],
      :twitter_id => params[:twitter_id]}

    Authentication.find(self.id).update_attributes parameters

    return JsonizeHelper.format :content => {:token => jotky_token}
  end

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

    post_twitter_status_request = Typhoeus::Request.new(post_twitter_status_url,
      :headers => { :Authorization => "OAuth #{headers}" },
      :method => :post,
      :params => { :status => CGI.escape(status) }
    )

    hydra = Typhoeus::Hydra.new
    hydra.queue(post_twitter_status_request)
    hydra.run

    post_twitter_status_response = ActiveSupport::JSON.decode post_twitter_status_request.response.body
    if not post_twitter_status_response['error'].present?
      post_twitter_status_response
    else
      "Something went wrong, please try again"
    end
  end

  # Twitter
  # ------------------------------------------------------------------------

  def current_user_add_google_account(code)
    body = "code=#{code}" +
      "&client_id=#{GOOGLE_CLIENT_ID}" +
      "&client_secret=#{GOOGLE_CLIENT_SECRET}" +
      "&redirect_uri=http://localhost:3000/me/google/authenticate_account&grant_type=authorization_code"

    google_token_response = ActiveSupport::JSON.decode Typhoeus::Request.post("https://accounts.google.com/o/oauth2/token", :body => body).body

    if google_token_response.empty? or google_token_response['error'].present?
      return "http://localhost:5000/omniauth/authenticate_google?error=Something%20went%20wrong,%20Please%20try%20again."
    else
      google_token = google_token_response['access_token']
      google_profile_response = XmlSimple.xml_in Typhoeus::Request.get("https://gdata.youtube.com/feeds/api/users/default", :params => {:access_token => google_token}).body
      jotky_token = ActiveSupport::SecureRandom.hex(9)

      parameters = {:google_user_youtube_id => google_profile_response['id'][0].gsub(/http:\/\/gdata.youtube.com\/feeds\/api\/users\/(.+)/, '\1'),
        :token => jotky_token,
        :google_user_token => google_token,
        :google_user_refresh_token => google_token_response['refresh_token'],
        :google_user_username => google_profile_response['username'][0],
        :google_user_token_expires_at => Time.now + google_token_response['expires_in']}

      self.update_attributes parameters
      self.update_attributes({:realname => google_profile_response['firstName'][0] + " " + google_profile_response['lastName'][0]}) if google_profile_response['firstName'].present?

      return "http://localhost:5000/omniauth/authenticate_google?username=#{self.username}&jotky_token=#{self.token}"
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
    message_array.push private_message
    message_array.push private_message.replies
    message_array.flatten
    return JsonizeHelper.format :content => message_array
  rescue
    return JsonizeHelper.format :failed => true, :error => "Failed to retrieve message"
  end
end

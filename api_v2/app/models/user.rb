require 'carrierwave/mongoid'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIVATE_FIELDS = [:password_salt, :password_hash, :token]

  PROTECTED_FIELDS = []

  PUBLIC_FIELD = [:username, :realname, :email, :password, :avatar, :bio, :url, :location,
    :setting_privacy_jot, :setting_privacy_location, :setting_privacy_kudos, :setting_auto_shorten_url,
    :setting_auto_complete, :connection_facebook_user_id, :connection_facebook_user_name]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS 

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = [:connections]

  RELATION_PUBLIC_DETAIL = []

  attr_accessor :password

  field :realname, type: String
  field :username, type: String
  field :email, type: String
  field :password_salt, :type => String
  field :password_hash, :type => String
  field :avatar, :type => String
  field :token, type: String
  field :bio, type: String, :default => ''
  field :url, type: String, :default => ''
  field :location, type: String, :default => ''
  
  field :facebook_id, :type => String
  field :twitter_id, :type => String

  field :setting_privacy_jot, :type => String, :default => 'everyone'
  field :setting_privacy_location, :type => String, :default => 'everyone'
  field :setting_privacy_kudos, :type => String, :default => 'everyone'
  field :setting_auto_shorten_url, :type => String, :default => 'always'
  field :setting_auto_complete, :type => String, :default => 'always'
  
  mount_uploader :avatar, AvatarUploader, :mount_on => :avatar

  has_many :jots
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :jot_favorites, :class_name => "Jot", :inverse_of => :user_favorites
  has_and_belongs_to_many :jot_thumbsup, :class_name => "Jot", :inverse_of => :user_thumbsup
  has_and_belongs_to_many :jot_thumbsdown, :class_name => "Jot", :inverse_of => :user_thumbsdown
  has_and_belongs_to_many :jot_mentioned, :class_name => "Jot", :inverse_of => :user_mentioned
  has_many :comments
  has_many :connections

  validates_format_of :url, :with => URI::regexp(%w(http https)), :allow_nil => true
  validates_format_of :email, :with => /\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/
  validates_format_of :username, :with => /^[A-Za-z0-9.\d_]+$/, :message => "can only be alphanumeric, dot and number with no spaces"
  validates_presence_of :realname, :username, :email
  validates_length_of :username, :minimum => 5
  validates_length_of :password, :minimum => 6, :allow_nil => true
  validates_uniqueness_of :username, :email, :case_sensitive => false

  validates_inclusion_of :setting_privacy_jot, :in => ["everyone", "friends", "hide"], :allow_nil => true
  validates_inclusion_of :setting_privacy_location, :in => ["everyone", "friends", "hide"], :allow_nil => true
  validates_inclusion_of :setting_privacy_kudos, :in => ["everyone", "friends", "hide"], :allow_nil => true
  validates_inclusion_of :setting_auto_shorten_url, :in => ["always", "ask", "never"], :allow_nil => true
  validates_inclusion_of :setting_auto_complete, :in => ["always", "ask", "never"], :allow_nil => true

  before_save :set_secure_password
  

  def self.get(parameters = {})
    parameters = parameters.to_hash rescue {}
    
    if parameters[:id].present?
      data = self.find parameters[:id]
    end

    JsonizeHelper.format({:content => data}, {
        :except => NON_PUBLIC_FIELDS,
        :include => RELATION_PUBLIC
      })
  rescue
    JsonizeHelper.format :failed => true, :error => 'User not found'
  end

  def get_my_attributes
    JsonizeHelper.format({:content => self}, {
        :except => NON_PUBLIC_FIELDS,
        :include => RELATION_PUBLIC
      })
  end

  def set_my_attributes(parameters)
    parameters.keep_if {|key, value| UPDATEABLE_FIELDS.include? key }

    if self.update_attributes parameters
      self.reload
      self.get_my_attributes
    else
      self.reload
      return JsonizeHelper.format :failed => true, :error => "Update was not made", :errors => self.errors.to_a
    end
  end

  def current_user_set_jot(parameters)
    parameters.keep_if {|key, value| Jot::UPDATEABLE_FIELDS.include? key }
    
    jot_data = self.jots.new parameters
    jot_data.save

    jot_data.current_jot_set_mention_users

    jot_data.tags.concat current_user_subcribe_tags(parameters[:title])
      
    jot_data.reload

    if jot_data.errors.any?
      return JsonizeHelper.format :failed => true, :error => "Jot was not made", :errors => jot_data.errors.to_a
    else
      return JsonizeHelper.format({:notice => "Jot Successfully Made", :content => jot_data}, {
          :except => Jot::NON_PUBLIC_FIELDS,
          :include => Jot::RELATION_PUBLIC
        })
    end
  end

  def current_user_subcribe_tags(string)
    data = Twitter::Extractor.extract_hashtags(string)
    
    new_tags = []

    data.uniq.each do |tag|
      new_tags.push Tag.find_or_create_by({:name => tag.downcase})
    end

    self.tags.concat new_tags
    self.reload

    new_tags
  end

  def current_user_get_jot(parameters)

    if parameters[:timestamp] == 'now'
      params_timestamp = Time.now()
    else
      params_timestamp = Time.iso8601(parameters[:timestamp])
    end
   
    data = Jot.before_the_time(params_timestamp, parameters[:per_page]).order_by_default

    JsonizeHelper.format({
        :content => data
      },
      {
        :except => Jot::NON_PUBLIC_FIELDS,
        :include => Jot::RELATION_PUBLIC
      }
    )
  rescue
    JsonizeHelper.format :failed => true, :error => 'Jot not found'
  end


  def current_user_set_favorite_jot(jot_id)
    jot = Jot.find(jot_id)
   
    unless jot.user_favorites.include? self
      jot.user_favorites.push self
    else
      jot.user_favorites.delete self
    end

    jot.reload

    JsonizeHelper.format(
      {:content => jot},
      {:except => Jot::NON_PUBLIC_FIELDS, :include => Jot::RELATION_PUBLIC}
    )
  rescue
    return JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_set_thumbs_up_jot(jot_id)
    jot = Jot.find(jot_id)

    jot.user_thumbsup.delete self

    jot.user_thumbsup.push self

    jot.user_thumbsdown.delete self

    jot.reload

    JsonizeHelper.format(
      {
        :notice => "Jot was thumbed up",
        :content => jot
      },
      {:except => Jot::NON_PUBLIC_FIELDS, :include => Jot::RELATION_PUBLIC}
    )    
  rescue
    JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_set_thumbs_down_jot(jot_id)
    jot = Jot.find(jot_id)

    jot.user_thumbsdown.delete self

    jot.user_thumbsdown.push self

    jot.user_thumbsup.delete self

    jot.reload

    JsonizeHelper.format(
      {
        :notice => "Jot was thumbed down",
        :content => jot
      },
      {:except => Jot::NON_PUBLIC_FIELDS, :include => Jot::RELATION_PUBLIC}
    )
  rescue
    JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_set_rejot(jot_id)
    jot = Jot.find(jot_id)

    rejot = jot.clone
    rejot.user = self
    rejot.save

    jot.rejots.push rejot

    JsonizeHelper.format :content => rejot
  rescue
    JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_set_jot_comments(jot_id, parameters)

    parameters.keep_if {|key, value| Comment::UPDATEABLE_FIELDS.include? key }

    data = self.comments.new parameters

    if data.save
      
      data.jot = Jot.find(jot_id)
      data.save
      data.reload

      JsonizeHelper.format({:content => data}, {:except => Comment::NON_PUBLIC_FIELDS, :include => Comment::RELATION_PUBLIC})
    else
      JsonizeHelper.format :failed => true, :error => "Comment was not made", :errors => data.errors.to_a
    end
  rescue
    JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_set_connections(parameters)
    parameters.keep_if {|key, value| Connection::UPDATEABLE_FIELDS.include? key }

    if parameters[:connection_name] == 'twitter'
      begin
        client = Twitter::Client.new :oauth_token => parameters[:connection_token], :oauth_token_secret => parameters[:connection_secret]
        data = client.verify_credentials

        parameters.merge!({
            :connection_user_id => data['id'],
            :connection_user_name => data['name'],
            :connection_token => parameters[:connection_token],
            :connection_secret => parameters[:connection_secret]
          })
      rescue
        return JsonizeHelper.format(:error => "aw hell no, can\'t connect to twitter", :failed => true)
      end
    elsif parameters[:connection_name] == 'facebook'

      send_request = Typhoeus::Request.new "https://graph.facebook.com/me?access_token=#{parameters[:connection_token]}"

      # Run the request via Hydra.
      hydra = Typhoeus::Hydra.new
      hydra.queue(send_request)
      hydra.run

      response = send_request.response

      if response.success?
        data = ActiveSupport::JSON.decode(response.body)

        parameters.merge!({
            :connection_user_id => data['id'],
            :connection_user_name => data['name'],
            :connection_token => parameters[:connection_token]
          })
      else
        return JsonizeHelper.format(:error => "aw hell no, can\'t connect to facebook", :failed => true)
      end

    end

    data = self.connections.where({:connection_name => parameters[:connection_name]}).first

    data = self.connections.new parameters
    data.save
    data.reload

    if data.errors.any?
      return JsonizeHelper.format :failed => true, :error => "Connections was not made", :errors => data.errors.to_a
    else
      return JsonizeHelper.format({:notice => 'Data Connected', :content => data}, {:except => Connection::NON_PUBLIC_FIELDS, :include => Connection::RELATION_PUBLIC})
    end
  end

  def current_user_unset_connections(id)
    data = Connection.find(id).destroy
    JsonizeHelper.format({:content => data}, {:except => Connection::NON_PUBLIC_FIELDS, :include => Connection::RELATION_PUBLIC})
  rescue
    JsonizeHelper.format :failed => true, :error => "Connection was not found"
  end

  protected

  def set_secure_password
    if self.password.present?
      encrypted_string_data = EncryptStringHelper.encrypt_string(password)
      self.password_salt = encrypted_string_data[:salt]
      self.password_hash = encrypted_string_data[:hash]
    end
  end
end
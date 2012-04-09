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

  RELATION_PUBLIC = []

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
  has_many :message_sent, :class_name => "Message", :inverse_of => :sender
  has_many :message_received, :class_name => "Message", :inverse_of => :receiver
  has_many :comments
  has_many :connections
  has_many :nests
  has_many :clips

  validates_format_of :url, :with => URI::regexp(%w(http https)), :allow_nil => true, :allow_blank => true
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

  def current_user_get_favorite_jot(limit)
    jot = self.jot_favorites
    jot = jot.limit(limit.to_i) if limit.present?

    JsonizeHelper.format(
      {:content => jot},
      {:except => Jot::NON_PUBLIC_FIELDS, :include => Jot::RELATION_PUBLIC}
    )
  rescue
    return JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_user_set_favorite_jot(jot_id)
    jot = Jot.find(jot_id)

    unless jot.user_favorites.include? self
      jot.user_favorites.push self

      jot.tags.each do |tag|
        tag.update_attribute 'meta_favorites', tag.meta_favorites + 1
      end
    else
      jot.user_favorites.delete self

      jot.tags.each do |tag|
        tag.update_attribute 'meta_favorites', tag.meta_favorites - 1
      end
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

    unless jot.user_thumbsup.include? self
      jot.user_thumbsup.push self

      jot.tags.each do |tag|
        tag.update_attribute 'meta_thumbups', tag.meta_thumbups + 1
      end
    end

    if jot.user_thumbsdown.include? self
      jot.user_thumbsdown.delete self

      jot.tags.each do |tag|
        tag.update_attribute 'meta_thumbdowns', tag.meta_thumbdowns - 1
      end
    end
    
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

    unless  jot.user_thumbsdown.include? self
      jot.user_thumbsdown.push self
      
      jot.tags.each do |tag|
        tag.update_attribute 'meta_thumbdowns', tag.meta_thumbdowns + 1
      end
    end

    if jot.user_thumbsup.include? self
      jot.user_thumbsup.delete self

      jot.tags.each do |tag|
        tag.update_attribute 'meta_thumbups', tag.meta_thumbups - 1
      end
    end

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

    if parameters[:provider] == 'twitter'
      begin
        client = Twitter::Client.new :oauth_token => parameters[:provider_user_token], :oauth_token_secret => parameters[:provider_user_secret]
        data = client.verify_credentials

        parameters.merge!({
            :provider_user_id => data['id'],
            :provider_user_name => data['screen_name'] || data['id'],
            :provider_user_token => parameters[:provider_user_token],
            :provider_user_secret => parameters[:provider_user_secret]
          })
      rescue
        return JsonizeHelper.format(:error => "aw hell no, can\'t connect to twitter", :failed => true)
      end
    elsif parameters[:provider] == 'facebook'

      send_request = Typhoeus::Request.new "https://graph.facebook.com/me?access_token=#{parameters[:provider_user_token]}"

      # Run the request via Hydra.
      hydra = Typhoeus::Hydra.new
      hydra.queue(send_request)
      hydra.run

      response = send_request.response

      if response.success?
        data = ActiveSupport::JSON.decode(response.body)

        parameters.merge!({
            :provider_user_id => data['id'],
            :provider_user_name => data['username'] || data['id'],
            :provider_user_token => parameters[:provider_user_token]
          })
      else
        return JsonizeHelper.format(:error => "aw hell no, can\'t connect to facebook", :failed => true)
      end

    end

    conn = self.connections.where({:provider => parameters[:provider], :provider_user_id => parameters[:provider_user_id]}).first

    if conn.present?
      conn.update_attributes parameters
    else
      conn = self.connections.new parameters
      conn.save
    end

    #data.reload

    if conn.errors.any?
      return JsonizeHelper.format :failed => true, :error => "Connections was not made", :errors => conn.errors.to_a
    else
      return JsonizeHelper.format({:notice => 'Data Connected', :content => conn}, {:except => Connection::NON_PUBLIC_FIELDS, :include => Connection::RELATION_PUBLIC})
    end
  end

  def current_user_unset_connections(id)
    data = Connection.find(id).destroy
    JsonizeHelper.format({:content => data}, {:except => Connection::NON_PUBLIC_FIELDS, :include => Connection::RELATION_PUBLIC})
  rescue
    JsonizeHelper.format :failed => true, :error => "Connection was not found"
  end

  def current_user_connections(parameters)
    data = self.connections.order_by_default
    
    if parameters[:provider].present? and parameters[:allowed].present?
      data = data.find_by_provider(parameters[:provider]).find_allowed
    elsif parameters[:provider].present?
      data = data.find_by_provider(parameters[:provider])
    end

    JsonizeHelper.format({:content => data}, {:except => Connection::NON_PUBLIC_FIELDS, :include => Connection::RELATION_PUBLIC})
  end

  def current_user_reset_connections(id, parameters)
    parameters.keep_if {|key, value| Connection::UPDATEABLE_FIELDS.include? key }

    data = Connection.find id

    data.update_attributes parameters
    data.reload
    JsonizeHelper.format({:content => data}, {:except => Connection::NON_PUBLIC_FIELDS, :include => Connection::RELATION_PUBLIC})
  rescue
    JsonizeHelper.format :failed => true, :error => "Connection was not found"
  end

  def set_nest(parameters)
    parameters.keep_if {|key, value| Nest::UPDATEABLE_FIELDS.include? key }

    data = self.nests.new parameters

    if data.save
      return JsonizeHelper.format({:notice => "Nest Successfully Made", :content => data}, {
          :except => Nest::NON_PUBLIC_FIELDS,
          :include => Nest::RELATION_PUBLIC
        })
    else
      return JsonizeHelper.format :failed => true, :error => "Nest was not made", :errors => data.errors.to_a
    end
  end

  def get_nest(parameters)
    data = self.nests.order_by_default

    return JsonizeHelper.format({:content => data}, {
        :except => Nest::NON_PUBLIC_FIELDS,
        :include => Nest::RELATION_PUBLIC
      })
  end

  def unset_nest(nest_id)
    data = self.nests.find(nest_id).destroy

    return JsonizeHelper.format :notice => "Nest Successfully Deleted"
  rescue
    JsonizeHelper.format :failed => true, :error => "Nest was not found"
  end

  def reset_nest(nest_id, parameters)
    parameters.keep_if {|key, value| Nest::UPDATEABLE_FIELDS.include? key }

    data = self.nests.find nest_id

    data.update_attributes parameters

    if data.errors.any?
      JsonizeHelper.format :failed => true, :error => "Nest was not made", :errors => data.errors.to_a
    else
      data.reload
      JsonizeHelper.format :content => data
    end

  rescue
    JsonizeHelper.format :failed => true, :error => "Nest was not found"
  end


  def set_nest_item(parameters)
    
    parameters.keep_if {|key, value| NestItem::UPDATEABLE_FIELDS.include? key }

    data = self.nests.find parameters[:nest_id]
    data_item = data.nest_items.new :name => parameters[:name]

    data_item.tag_ids.concat parameters[:tags].flatten.uniq if parameters[:tags].present?

    data_item.save

    if data_item.errors.any?
       JsonizeHelper.format :failed => true, :error => data_item.errors.to_a
    else
      JsonizeHelper.format :content => data_item
    end
  rescue
    JsonizeHelper.format :failed => true, :error => "Nest was not found"
  end

  def current_user_get_message
    message = Message.any_of({ :sender_id => self.id }, { :receiver_id => self.id }).desc(:updated_at)

    JsonizeHelper.format :content => message
  end

  def current_user_set_message(receiver, subject, content)
    receiver = User.where(:username => receiver).first

    if receiver.present?
      self.message_sent.create! :receiver => receiver, :subject => subject, :content => content
      JsonizeHelper.format :notice => "Your message have been sent"
    else
      JsonizeHelper.format :failed => true, :error => "The user doesn't exist"
    end

  rescue
    JsonizeHelper.format :failed => true, :error => "Your message cannot be sent, please try again"
  end

  def current_user_set_message_mark_read(message_id)
    message = Message.find(message_id)

    message.update_attributes :read => true

    JsonizeHelper.format :notice => "Your message is marked"
  rescue
    JsonizeHelper.format :failed => true, :error => "Your message cannot be found"
  end

  def current_user_unset_message(message_id)
    message = Message.find(message_id)

    message.destroy

  rescue
    JsonizeHelper.format :failed => true, :error => "Your message could not be found"
  end

  def current_user_set_message_reply(message_id, content)
    message = Message.find(message_id)

    parameters = {:subject => "Re: #{message.subject}",
                  :from => self.username,
                  :to => message.to,
                  :content => content,
                  :original_message => message}

    message.replies.create! parameters
    message.update_attributes :read => false

    JsonizeHelper.format :notice => "You have replied"
  rescue
    JsonizeHelper.format :failed => true, :error => "Something went wrong, please try again"
  end

  def current_user_get_message_reply(message_id)
    messages = Message.find(message_id).replies.asc(:created_at)

    JsonizeHelper.format :content => messages
  rescue
    JsonizeHelper.format :failed => true, :error => "Message not found, please try again"
  end

  def set_clip(parameters)
    parameters.keep_if {|key, value| Clip::UPDATEABLE_FIELDS.include? key }

    data = self.clips.new parameters
    data.save
    JsonizeHelper.format :content => data
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
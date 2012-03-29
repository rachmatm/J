require 'carrierwave/mongoid'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIVATE_FIELDS = [:password_salt, :password_hash]

  PROTECTED_FIELDS = []

  PUBLIC_FIELD = [:username, :realname, :email, :password, :registration_completion]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = [:jot_favorites]

  RELATION_PUBLIC_DETAIL = []

  field :realname, type: String
  field :username, type: String
  field :email, type: String
  field :password_salt, :type => String
  field :password_hash, :type => String
  field :avatar, :type => String
  field :token, type: String
  
  mount_uploader :avatar, AvatarUploader, :mount_on => :avatar

  has_many :jots
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :jot_favorites, :class_name => "Jot", :inverse_of => :user_favorites
  has_and_belongs_to_many :jot_thumbsup, :class_name => "Jot", :inverse_of => :user_thumbsup
  has_and_belongs_to_many :jot_thumbsdown, :class_name => "Jot", :inverse_of => :user_thumbsdown
  has_and_belongs_to_many :jot_mentioned, :class_name => "Jot", :inverse_of => :user_mentioned

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
end
class Jot
  include Mongoid::Document
  include Mongoid::Timestamps

  # ---------------------------------------------------------------------------
  #
  # Relations
  # ---------------------------------------------------------------------------
  has_and_belongs_to_many :tags
  #embeds_many :tags
  accepts_nested_attributes_for :tags

  #has_and_belongs_to_many :tags
  has_many :comments
  
  embeds_many :kudos
  belongs_to :user
  has_and_belongs_to_many :user_favorites, :class_name => 'User', :inverse_of => :jot_favorites
  has_and_belongs_to_many :user_thumbs_up, :class_name => 'User', :inverse_of => :jot_thumbs_up
  has_and_belongs_to_many :user_thumbs_down, :class_name => 'User', :inverse_of => :jot_thumbs_down

  has_many :attachments

  has_many :locations

  has_and_belongs_to_many :user_rejoters, :class_name => 'User', :inverse_of => :jot_rejoters

  # ---------------------------------------------------------------------------
  #
  # FIELD
  # ---------------------------------------------------------------------------
  #
  # -- Account Information
  field :title, :type => String
  field :detail, :type => String

  # ---------------------------------------------------------------------------
  #
  # Validation
  # ---------------------------------------------------------------------------
  #
  # -- Presence
  validates_presence_of :title, :user
  #
  # -- Length
  validates_length_of :title, :maximum => 140
  validates_length_of :detail, :maximum => 512

  # ---------------------------------------------------------------------------
  #
  # SCOPES
  # ---------------------------------------------------------------------------
  #
  scope :public_data, without()
  scope :default_order, order_by([:created_at, :desc])
  scope :show_more, ->(skip, per_page) { skip(skip.to_i).limit(per_page.to_i)}
  scope :paginate, ->(per_page, page) { skip(per_page.to_i * (page.to_i - 1)).limit(per_page.to_i)}

  #
  scope :page, ->(page, per_page) { skip(per_page.to_i * (page.to_i - 1)).limit(per_page.to_i)}
  scope :order_by_default, order_by([[:updated_at, :desc]])
  scope :before_the_time, ->(timestamp, per_page) { where(:updated_at.lt => timestamp).limit(per_page.to_i)}
  scope :find_by_user_tags, ->(user) {any_of({"tag_ids" => {"$in" => user.tags.collect{|tag| tag.id}}}, {'user_id' => user.id})}

  # ---------------------------------------------------------------------------
  #
  # CALLBACKS
  # ---------------------------------------------------------------------------
  after_create :trigger_realtime_info_create
  after_destroy :trigger_realtime_info_destroy
  after_create :after_create_set_tag_meta
  after_destroy :after_destroy_unset_tag_meta
  after_create :after_create_append_notification

  PRIVATE_FIELDS = []

  PROTECTED_FIELDS = []

  PUBLIC_FIELD = [:title,:detail,:attachments,:created_at,:updated_at,:locations,:attachments]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = [:attachments,:tags,:user,:locations,:user_rejoters]

  RELATION_PUBLIC_DETAIL = [:comments]

  def self.get(params = {})
    request_query = {}
    respond_include = []

    if params[:id].present?
      data =  self.find params[:id]

      request_query = {:total_jot => 1}
      respond_include = RELATION_PUBLIC_DETAIL

    elsif params[:per_page].present? and params[:page].present?

      data = self.page(params[:page], params[:per_page]).order_by_default

      request_query = {
        :per_page => params[:per_page].to_i,
        :page => params[:page].to_i,
        :total_jot => data.count,
        :total_page => (data.count / params[:per_page].to_f).ceil }

    else
      data = self.order_by_default

      request_query = {:total_jot => data.count}
    end

    JsonizeHelper.format({
        :content => data,
        :query => {:per_page => nil, :page => nil, :total_jot => nil, :total_page => nil }.merge(request_query)
      },
      {
        :except => NON_PUBLIC_FIELDS,
        :include => RELATION_PUBLIC + respond_include
      })
  rescue
    JsonizeHelper.format :failed => true, :error => 'Jot not found'
  end

  def self.get_comment(jot_id, parameters)
    jot = Jot.find jot_id
    request_query = {}

    if parameters[:per_page].present? and parameters[:page].present?
      data = jot.comments.where(:jot_id => jot_id).page(parameters[:page], parameters[:per_page]).order_by_default

      request_query = {
        :per_page => parameters[:per_page].to_i,
        :page => parameters[:page].to_i,
        :total_comment => data.count,
        :total_page => (data.count / parameters[:per_page].to_f).ceil }
    end

    JsonizeHelper.format({
        :content => data,
        :query => {:per_page => nil, :page => nil, :total_comment => nil, :total_page => nil}.merge(request_query)
      },
      {
        :except => Comment::NON_PUBLIC_FIELDS,
        :include => Comment::RELATION_PUBLIC
      })

  rescue
    JsonizeHelper.format :failed => true, :error => 'Jot not found'
  end

  def self.get_search(texts)
    users = Twitter::Extractor.extract_mentioned_screen_names(texts)
    hashtags = Twitter::Extractor.extract_hashtags(texts)

    text_array = []

    search_type = users.present? ? users : hashtags
    search_type = search_type.present? ? search_type : texts.split(/\s|,\s|,/)

    search_criteria = users.present? ? {:user_id.in => text_array} : {:tag_ids.all => text_array}
    search_criteria = (users.present? or hashtags.present?) ? search_criteria : {:title.all => text_array}

    search_type.each do |text|
      text_regex = /#{text}/i
      text_array.push(text_regex)
    end

    search_result = ActiveSupport::JSON.encode Jot.where(search_criteria)

    JsonizeHelper.format :content => search_result
  end

  #  def self.get(per_page = nil, page = nil)
  #    responds = Hash.new
  #    responds[:content] = self.public_data.default_order
  #    responds[:content] = responds[:content].paginate(per_page, page) if per_page.present? and page.present?
  #    responds[:total_jot] = responds[:content].count
  #    responds[:current_page] = page || 1
  #    responds[:total_page] = (responds[:total_jot].to_f / per_page).ceil rescue 1
  #
  #    JsonizeHelper.format responds
  #  end
  #
  #  def self.get_single(id)
  #    jot = Jot.find(id)
  #    return JsonizeHelper.format :content => jot
  #  rescue
  #    return JsonizeHelper.format :failed => true, :error => "The following jot #{id} could not be found"
  #  end
  #
  #  def self.get_more(skip, limit)
  #    responds = Hash.new
  #    responds[:content] = self.public_data.default_order.show_more(skip, limit)
  #    responds[:next_count_id] = (next_count_id = limit.to_i + skip.to_i) < responds[:content].count ? next_count_id : nil
  #    JsonizeHelper.format responds
  #  end
  #
  #  # TODO: Delete
  #  # has moved to user
  #  def self.set(user_id, params)
  #    jot = Jot.create params
  #    if jot.errors.any?
  #      return JsonizeHelper.format :failed => true, :error => "Jot was not made", :errors => jot.errors.to_a
  #    else
  #      begin
  #        Pusher['jots'].trigger!('jot_create', jot)
  #      rescue Pusher::Error => e
  #        # (Pusher::AuthenticationError, Pusher::HTTPError, or Pusher::Error)
  #      end
  #
  #      return JsonizeHelper.format :content => jot, :notice => "Jot Successfully Made"
  #    end
  #  end

  # TODO: Delete
  # has moved to user
  def self.unset(id)
    jot_destroy = Jot.find(id).destroy
    if jot_destroy
      JsonizeHelper.format :notice => "Jot is successfully destroyed"
    else
      JsonizeHelper.format :failed => true, :error => "Jot is not successfully destroyed"
    end
  rescue
    JsonizeHelper.format :failed => true, :error => "Jot was not found"
  end

  def current_jot_set_tags(array_tag=[])
    if array_tag.present? and array_tag.is_a? Array
      array_tag.each do |tag_name|
        next if self.tags.collect{ |tag| tag.name.downcase }.include?(tag_name.downcase)
           
        tag = self.tags.find_or_create_by :name => tag_name.downcase
        
        #add metadata
        tag.meta[:weight] = tag.metadata[:weight].to_i + 1
        tag.save
      end
    else
      raise "Wrong Parameter"
    end

    self.tags
  end

  #--------
  def before_create_set_tag_meta
    jot.tags.each
  end


  protected
  def trigger_realtime_info_create
    #    begin
    #      Pusher['jots'].trigger!('jot_create', self)
    #    rescue Pusher::Error => e
    #      # TODO : need a fallback
    #      # (Pusher::AuthenticationError, Pusher::HTTPError, or Pusher::Error)
    #    end
  end

  def trigger_realtime_info_destroy
    #    begin
    #      Pusher['jots'].trigger!('jot_delete', self)
    #    rescue Pusher::Error => e
    #      # TODO : need a fallback
    #      # (Pusher::AuthenticationError, Pusher::HTTPError, or Pusher::Error)
    #    end
  end

  def after_create_set_tag_meta
    self.tags.each do |tag|
      tag._current_tag_set_meta 'weight' => (tag.meta['weight'].to_i + 1)

      _tag_tag_ids = self.tags.collect{|tag2| tag2.id }
      tag.tag_tag_ids.concat(_tag_tag_ids).delete(tag.id)
      tag.tag_tag_ids.uniq!
      tag.save
    end
  end

  def after_destroy_unset_tag_meta
    self.tags.each do |tag|
      unless tag.jots.any?
        tag.destroy
      else
        tag._current_tag_set_meta 'weight' => (tag.meta['weight'].to_i - 1)
      end
    end
  end

  def after_create_append_notification
    mentions = Twitter::Extractor.extract_mentioned_screen_names(self.title)
    mentions.each do |mention|
      user = User.where(:username => mention).first
      parameters = {:type => 'user',
                    :authors => [self.user_id],
                    :summary => 'mentioned you in his/her',
                    :content => self.title,
                    :time => self.created_at,
                    :jot_id => self.id}

      user.notifications.create parameters if user.present? and mention != self.user_id
    end
  end
end

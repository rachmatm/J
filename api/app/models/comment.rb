class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  # ---------------------------------------------------------------------------
  #
  # Relations
  # ---------------------------------------------------------------------------

  belongs_to :jot
  belongs_to :user

  # ---------------------------------------------------------------------------
  #
  # FIELD
  # ---------------------------------------------------------------------------
  field :detail, :type => String

  PRIVATE_FIELDS = []

  PROTECTED_FIELDS = []

  PUBLIC_FIELD = [
    :detail,
    :created_at,
    :updated_at
  ]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = [
    :user
  ]

  # ---------------------------------------------------------------------------
  #
  # SCOPES
  # ---------------------------------------------------------------------------
  scope :page, ->(page, per_page) { skip(per_page.to_i * (page.to_i - 1)).limit(per_page.to_i)}
  scope :order_by_default, order_by([[:updated_at, :asc]])

  # ---------------------------------------------------------------------------
  #
  # CALLBACKS
  # ---------------------------------------------------------------------------
  #
  after_create :after_create_append_notification

  #  def self.set(user_id, jot_id, content)
  #    current_comment = Jot.find(jot_id).comments.create :user_id => user_id, :author => User.find(user_id).username, :content => content
  #
  #    if current_comment.errors.any?
  #      return JsonizeHelper.format :failed => true, :error => "Comment was not made", :errors => current_comment.errors.to_a
  #    else
  #      return JsonizeHelper.format :notice => "Comment Successfully Made"
  #    end
  #
  #  rescue
  #    return JsonizeHelper.format :failed => true, :error => "Jot or User doesn't exist"
  #  end
  #
  #  def self.unset(jot_id, comment_id)
  #      current_jot_comment_destroy = Jot.find(jot_id).comments.find(comment_id).destroy
  #
  #      if current_jot_comment_destroy
  #        return JsonizeHelper.format :notice => "Comment was destroyed"
  #      else
  #        return JsonizeHelper.format :failed => true, :error => "Comment was not destroyed"
  #      end
  #    rescue
  #      return JsonizeHelper.format :failed => true, :error => "Comment doesn't exist"
  #  end

  def after_create_append_notification
    jot = Jot.find(self.jot_id)
    user = User.find(jot.user_id)
    same_type_notifications = user.notifications.where(:jot_id => self.jot_id, :type => 'jot').first

    # If the same type of notification is available it will
    # only update the parameters of the said notification
    if same_type_notifications.present?
      same_type_notifications.update_attributes :content => self.detail, :time => self.created_at
      same_type_notifications.authors << self.user_id unless same_type_notifications.authors.include? self.user_id and self.user_id == jot.user_id
    else
      parameters = {:type => 'jot',
                    :authors => [self.user_id],
                    :summary => " replied your",
                    :content => self.detail,
                    :time => self.created_at,
                    :jot_id => self.jot_id}

      notification = user.notifications.create parameters unless self.user_id == jot.user_id
    end

    user.save

  # Rescue to nothing, just a fallback in case something happens
  rescue
  end
end

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIVATE_FIELDS = []

  PROTECTED_FIELDS = []

  PUBLIC_FIELD = [:message]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = [:user]

  RELATION_PUBLIC_DETAIL = []

  field :message, :type => String

  validates_presence_of :message

  belongs_to :jot
  belongs_to :user

  scope :page, ->(page, per_page) { skip(per_page.to_i * (page.to_i - 1)).limit(per_page.to_i)}
  scope :order_by_default, order_by([[:updated_at, :asc]])

  def self.get_comments(jot_id, options = {})

    data = self.where({:jot_id => jot_id}).order_by_default

    if options[:page].present? and options[:per_page].present?
      data = data.page(options[:page], options[:per_page])
    end

    JsonizeHelper.format({:content => data}, {:except => Comment::NON_PUBLIC_FIELDS, :include => Comment::RELATION_PUBLIC})
  end
end
class Connection
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIVATE_FIELDS = []

  PROTECTED_FIELDS = [:provider_user_token, :provider_user_secret]

  PUBLIC_FIELD = [:provider, :provider_user_id, :provider_user_name, :provider_user_token, :provider_user_secret, :permission]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = []

  RELATION_PUBLIC_DETAIL = []

  field :provider, :type => String
  field :provider_user_id, :type => String
  field :provider_user_name, :type => String
  field :provider_user_token, :type => String
  field :provider_user_secret, :type => String
  field :permission, :type => String, :default => 'allow'

  validates_presence_of :provider_user_id, :provider_user_name, :provider_user_token

  validates_inclusion_of :permission, :in => ["allow", "deny", "always"], :allow_nil => true

  belongs_to :user

  scope :order_by_default, order_by([[:update_at, :desc]])
  scope :find_by_provider, ->(provider){where(:provider => provider)}
  scope :find_allowed, where(:permission => 'allow')
end
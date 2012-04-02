class Connection
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIVATE_FIELDS = []

  PROTECTED_FIELDS = [:connection_token, :connection_secret]

  PUBLIC_FIELD = [:connection_name, :connection_user_id, :connection_user_name, :connection_token, :connection_secret]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = []

  RELATION_PUBLIC_DETAIL = []

  field :connection_name, :type => String
  field :connection_user_id, :type => String
  field :connection_user_name, :type => String
  field :connection_token, :type => String
  field :connection_secret, :type => String

  validates_presence_of :connection_user_id, :connection_user_name, :connection_token

  belongs_to :user
end
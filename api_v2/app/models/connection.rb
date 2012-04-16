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

  FACEBOOK_FLAG = 'facebook'

  TWITTER_FLAG = 'twitter'

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

  def self.auth_facebook(secret_token, &block)
    send_request = Typhoeus::Request.new "https://graph.facebook.com/me?access_token=#{secret_token}"

    # Run the request via Hydra.
    hydra = Typhoeus::Hydra.new
    hydra.queue(send_request)
    hydra.run

    response = send_request.response

    yield response.success?, ActiveSupport::JSON.decode(response.body)
  rescue
    yield false, {}
  end

  def self.auth_twitter(token, secret)
    client = Twitter::Client.new :oauth_token => token, :oauth_token_secret => secret
    data = client.verify_credentials

    yield true, data
  rescue
    yield false, {}
  end
end
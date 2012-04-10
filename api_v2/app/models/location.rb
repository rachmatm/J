class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIVATE_FIELDS = []

  PROTECTED_FIELDS = []

  PUBLIC_FIELD = [:name]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = []

  RELATION_PUBLIC_DETAIL = []

  field :name, :type => String
  field :latitude, :type => String
  field :longitude, :type => String
  field :gmaps, :type => String

  def gmaps4rails_address
    #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
    # https://github.com/apneadiving/Google-Maps-for-Rails
    "#{self.name}"
  end
end
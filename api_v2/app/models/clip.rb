require 'carrierwave/mongoid'

class Clip
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIVATE_FIELDS = []

  PROTECTED_FIELDS = []

  PUBLIC_FIELD = []

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = []

  RELATION_PUBLIC_DETAIL = []

  attr_accessor :file

  field :name, :type => String
  field :src, :type => String

  before_save :current_jot_set_crosspost

  protected

  def current_jot_set_crosspost
    
  end
end
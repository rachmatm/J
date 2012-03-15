require 'carrierwave/mongoid'

class Attachment
  include Mongoid::Document
  include Mongoid::Timestamps

  #-- Relations
  has_and_belongs_to_many :users
  has_and_belongs_to_many :jots

  #-- Fields
  field :file, :type => String

  #-- Uploader
  mount_uploader :file, AttachmentUploader, :mount_on => :file

  #-- Validations
  validates_presence_of :file
  validates_integrity_of :file
  validates_processing_of :file
  validates :file, :file_size => { :maximum => 2.gigabytes.to_i }


  def self.set(params)
    data = self.create params

    if data.errors.any?
      JsonizeHelper.format({:error => 'Upload failed', :errors => data.errors, :failed => true})
    else
      JsonizeHelper.format({:content => data})
    end
  end
end
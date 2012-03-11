class AttachmentUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "/files/#{model.class.to_s.underscore}/#{model.id}"
  end

  def root
    Server::Application.root 'public'
  end
end
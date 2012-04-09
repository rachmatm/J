class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Meta
  
  storage :file

  process :store_meta

  def store_dir
    "./files/#{model.class.to_s.underscore}/#{mounted_as}/#{ActiveSupport::SecureRandom.hex(10)}"
  end

  def root
    Server::Application.root
  end
end

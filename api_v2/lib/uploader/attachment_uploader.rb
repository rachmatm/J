class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Meta
  
  storage :file

  process :store_meta

  def store_dir
    "./files/#{model.class.to_s.underscore}/#{mounted_as}/#{ActiveSupport::SecureRandom.hex(10)}"
  end

  def root
    Server::Application.root 'public'
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "/files/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  def url
    _original_url = super
    Server::Application.assets _original_url
  end

end

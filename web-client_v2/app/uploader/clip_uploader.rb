class ClipUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Meta

  storage :file

  process :store_meta

  def store_dir
    "./files/#{Time.now.to_i}/#{SecureRandom.hex(10)}"
  end

  def root
    Rails.root
  end
end

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  #include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  
  process :resize_and_pad => [400, 400, '#FFFFFF']  

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "/images/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  def root
    Server::Application.root 'public'
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  def scale(width, height)
    # do something
  end
  
  def crop(x, y, width, height)
    manipulate! do |img|
      img.crop!(x.to_i, y.to_i, width.to_i, height.to_i)
      img = yield(img) if block_given?
      img
    end
  end

  # Create different versions of your uploaded files:
  version :thumb_big do
    process :resize_to_fill => [70, 70]
  end
  
  version :thumb_small do
    process :resize_to_fill => [20, 20]
  end
  
  version :thumb_medium do
    process :resize_to_fill => [50, 50]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
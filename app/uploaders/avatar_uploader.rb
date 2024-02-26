class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # Choose what kind of storage to use for this uploader:
  storage :file
  # If you're using cloud storage like Amazon S3, uncomment the line below
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [50, 50]
    process :optimize_image
  end

  version :medium do
    process resize_to_fit: [300, 300]
    process :optimize_image
  end

  version :large do
    process resize_to_fit: [500, 500]
    process :optimize_image
  end

  # Set secure permissions for uploaded files
  def permissions
    0o644
  end

  # Set secure permissions for uploaded directories
  def directory_permissions
    0o755
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  # Override the filename of the uploaded files.
  # Avoid using model.id or version_name here to improve security.
  # Use SecureRandom.uuid or a similar method instead.
  # This helps prevent attackers from guessing or enumerating file URLs.
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

  # Generate a unique token for the uploaded file's filename.
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  # Optimize the image with jpegoptim and optipng
  def optimize_image
    manipulate! do |img|
      img.strip
      img.combine_options do |c|
        c.quality '80'
        c.depth '8'
        c.interlace 'plane'
      end
      img
    end
  end
end

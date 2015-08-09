# encoding: utf-8
if Rails.env.production?
  class AuthorPhotoUploader < CarrierWave::Uploader::Base
    include Cloudinary::CarrierWave

    process :convert => 'jpg'

    version :standard do
      process :resize_to_fill => [250, 250, :north]
    end

    version :thumbnail do
      resize_to_fit(50, 50)
    end
  end

else
  class AuthorPhotoUploader < CarrierWave::Uploader::Base
    storage :file

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    version :standard do
      # process resize_to_fill: [300, 400, :north]
      # process resize_to_fit: [300, 400, :north]
    end

    version :thumbnail do
      # process resize_to_fit: [120, 200]
    end

  end

end
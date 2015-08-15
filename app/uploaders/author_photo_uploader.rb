# encoding: utf-8
if Rails.env.production?
  class AuthorPhotoUploader < CarrierWave::Uploader::Base
    include Cloudinary::CarrierWave

    process convert: 'jpg'
    process resize_to_fill: [250, 250, :north]
    cloudinary_transformation quality: 90

    version :thumbnail do
      resize_to_fit(50, 50)
      cloudinary_transformation quality: 70
    end
  end

else
  class AuthorPhotoUploader < CarrierWave::Uploader::Base
    storage :file

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    version :thumbnail do
      # process resize_to_fit: [120, 200]
    end

  end

end
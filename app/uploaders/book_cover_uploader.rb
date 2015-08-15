# encoding: utf-8
class BookCoverUploader < CarrierWave::Uploader::Base

  if Rails.env.production?
    include Cloudinary::CarrierWave

    process convert: 'jpg'
    process resize_to_fill: [300, 400, :north]
    cloudinary_transformation quality: 90

    version :thumbnail do
      resize_to_fit(120, 200)
      cloudinary_transformation quality: 70
    end
  else

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    version :thumbnail do

    end
  end




end
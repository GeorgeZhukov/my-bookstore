class Author < ActiveRecord::Base
  mount_uploader :photo, AuthorPhotoUploader
end

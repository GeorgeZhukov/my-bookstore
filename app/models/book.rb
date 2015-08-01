class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :category

  mount_uploader :cover, BookCoverUploader
end

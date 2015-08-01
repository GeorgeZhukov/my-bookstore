class Author < ActiveRecord::Base
  acts_as_paranoid
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :books

  mount_uploader :photo, AuthorPhotoUploader
end

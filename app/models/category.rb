class Category < ActiveRecord::Base
  acts_as_paranoid
  validates :title, presence: true, uniqueness: {case_sensitive: false}
  has_many :books
end

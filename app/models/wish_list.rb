class WishList < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :books
  validates :user, presence: true
end

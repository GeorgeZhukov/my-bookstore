class Address < ActiveRecord::Base

  validates :address, presence: true
  validates :zip_code, presence: true
  validates :city, presence: true
  validates :phone, presence: true
  validates :country, presence: true

  belongs_to :user

end

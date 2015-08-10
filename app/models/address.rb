class Address < ActiveRecord::Base

  validates :address, presence: true
  validates :zip_code, presence: true
  validates :city, presence: true
  validates :phone, presence: true
  validates :country, presence: true
  validates_zipcode :zipcode, if: "Rails.env.production?"

  belongs_to :user

  def country_alpha2
    country
  end
end

class Address < ActiveRecord::Base

  validates :address, presence: true
  validates :zip_code, presence: true
  validates :city, presence: true
  validates :phone, presence: true
  validates :country, presence: true

  belongs_to :user

  def eq(address)
    unless self.id && address.id && self.id == address.id
      fields_to_eq = [:address, :zip_code, :city, :phone, :country]

      fields_to_eq.each do |field|
        return false if self[field] != address[field]
      end
    end

    true
  end

  def country_name
    c = ISO3166::Country[country]
    c.translations[I18n.locale.to_s] || c.name
  end

end

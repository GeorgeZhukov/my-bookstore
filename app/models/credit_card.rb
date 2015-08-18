class ExpirationValidator < ActiveModel::Validator
  def validate(record)
    if record.expiration_month && record.expiration_year
      expiration_date = DateTime.new(record.expiration_year, record.expiration_month)
      if Date.today > expiration_date
        record.errors[:expiration_month] << "Check expiry date."#I18n.t("")
        record.errors[:expiration_year] << "Check expiry date."#I18n.t("")
      end
    end
  end
end

class CreditCard < ActiveRecord::Base
  has_many :orders
  belongs_to :user

  include ActiveModel::Validations
  validates_with ExpirationValidator

  validates :number, presence: true, credit_card_number: true
  validates :CVV, presence: true
  validates :expiration_month,
            presence: true,
            numericality: {
                only_integer: true,
                greater_than_or_equal_to: 1,
                less_than_or_equal_to: 12
            }
  validates :expiration_year,
            presence: true,
            numericality: {
                only_integer: true,
                greater_than_or_equal_to: Time.now.year,
                less_than_or_equal_to: Time.now.year + 10
            }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :user, presence: true

end

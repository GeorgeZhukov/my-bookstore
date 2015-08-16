class CreditCard < ActiveRecord::Base
  has_many :orders
  belongs_to :user

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

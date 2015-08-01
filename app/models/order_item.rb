class QuantityValidator < ActiveModel::Validator
  def validate(record)
    if record.book
      unless (1..record.book.books_in_stock).include? record.quantity
        record.errors[:quantity] << 'Wrong quantity.'
      end
    end
  end
end

class OrderItem < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with QuantityValidator

  # validates :price, presence: true
  validates :quantity, presence: true

  belongs_to :book
  belongs_to :order

  def price
    book.price * quantity
  end
end

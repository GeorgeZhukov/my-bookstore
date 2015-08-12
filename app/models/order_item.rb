class QuantityValidator < ActiveModel::Validator
  def validate(record)
    if record.book
      unless (1..record.book_books_in_stock).include? record.quantity
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

  delegate :title, :books_in_stock, :price, to: :book, prefix: true

  before_save do
    self.price = book_price * quantity
  end

  # Decrease books quantity when order sent to custom
  def take_books
    book.books_in_stock -= quantity
  end

  # Restore books quantity when order was canceled
  def restore_books
    book.books_in_stock += quantity
  end

  def to_s
    "#{book} x#{quantity}"
  end
end

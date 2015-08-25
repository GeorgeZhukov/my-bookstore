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

  belongs_to :book
  belongs_to :order

  validates :quantity, presence: true
  validates :book, presence: true
  # validates :order, presence: true

  delegate :title, :books_in_stock, :price, to: :book, prefix: true

  before_save do
    update_price!
  end

  def to_s
    "#{book} x#{quantity}"
  end

  def update_price!
    self.price = book_price * quantity
  end
end

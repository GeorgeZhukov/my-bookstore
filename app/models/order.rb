class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  belongs_to :delivery_service
  belongs_to :credit_card
  has_many :order_items

  def add_book(book, quantity=1)
    order_item = self.order_items.where(book: book).first
    if order_item
      order_item.quantity += quantity
    else
      order_item = self.order_items.build(book: book, quantity: quantity)
    end
    order_item.price = book.price * order_item.quantity
    order_item.save
  end

  def calculate_total_price
    return 0 if order_items.empty?
    self.order_items.map(&:price).inject(&:+) + delivery_service.price
  end
end


class Order < ActiveRecord::Base
  include AASM

  belongs_to :billing_address, class_name: "Address"
  belongs_to :shipping_address, class_name: "Address"
  belongs_to :user
  belongs_to :book
  belongs_to :delivery_service
  belongs_to :credit_card
  has_many :order_items

  scope :in_progress, -> { where(state: :in_progress) }

  aasm column: "state" do
    state :in_progress, initial: true
    state :in_queue
    state :in_delivery, before_enter: :take_books
    state :delivered, after_enter: :notify_user
    state :canceled, after_enter: :restore_books

    event :checkout do
      transitions from: :in_progress, to: :in_queue
    end

    event :confirm do
      transitions from: :in_queue, to: :in_delivery
    end

    event :finish do
      transitions from: :in_delivery, to: :delivered
    end

    event :cancel do
      transitions from: [:in_queue, :in_delivery, :delivered], to: :canceled
    end
  end

  def notify_user
    # todo: send email
  end

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


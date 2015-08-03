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
  scope :in_queue, -> { where(state: :in_queue) }
  scope :in_delivery, -> { where(state: :in_delivery) }
  scope :delivered, -> { where(state: :delivered) }

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
      transitions from: [:in_queue, :in_delivery], to: :canceled
    end
  end

  rails_admin do
    list do
      field :state, :state
    end
    edit do
      field :state, :state
    end

    state({
              events: {confirm: 'btn-warning', finish: 'btn-success', cancel: 'btn-danger'},
              states: {in_queue: 'label-info', in_delivery: 'label-warning', delivered: 'label-success'},
              disable: [:checkout]
          })
  end

  def notify_user
    # todo: send email
  end

  def take_books
    order_items.map(&:take_books)
  end

  def restore_books
    order_items.map(&:restore_books)
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
    result = 0
    result += order_items.map(&:price).inject(&:+) if self.order_items.exists?
    result += delivery_service.price if self.delivery_service
    result
  end
end


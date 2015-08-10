class Order < ActiveRecord::Base

  belongs_to :billing_address, class_name: "Address"
  belongs_to :shipping_address, class_name: "Address"
  belongs_to :user
  belongs_to :book
  belongs_to :delivery_service
  belongs_to :credit_card
  has_many :order_items

  default_scope { order(created_at: :desc) }

  scope :in_progress, -> { where(state: :in_progress) }
  scope :in_queue, -> { where(state: :in_queue) }
  scope :in_delivery, -> { where(state: :in_delivery) }
  scope :delivered, -> { where(state: :delivered) }

  after_create do
    calculate_total_price
  end

  state_machine :state, initial: :in_progress do
    before_transition :in_progress => :in_queue, do: :generate_number
    before_transition any => :in_delivery, do: :take_books
    after_transition any => :delivered, do: :notify_user
    after_transition any => :canceled, do: :restore_books

    event :checkout do
      transition :in_progress => :in_queue
    end

    event :confirm do
      transition :in_queue => :in_delivery
    end

    event :finish do
      transition :in_delivery => :delivered
    end

    event :cancel do
      transition [:in_queue, :in_delivery] => :canceled
    end

    state :in_progress
    state :in_queue
    state :in_delivery
    state :delivered
    state :canceled
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

  def generate_number
    unless number
      self.number = "R#{id.to_s.rjust(9, '0')}" # Get order id and fill it to with zeroes
      self.save
    end
  end

  def empty?
    !order_items.exists?
  end

  def clear
    order_items.destroy_all
    # self.shipping_address=nil
    # self.billing_address=nil
    self.delivery_service=nil
    calculate_total_price
  end

  def notify_user
    self.completed_date = DateTime.now
    UserMailer.delivered_email(user, self).deliver_later
  end

  def take_books
    order_items.map(&:take_books)
  end

  def books_count
    order_items.map(&:quantity).inject(&:+) || 0
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

    calculate_total_price
  end

  def calculate_books_price
    order_items.map(&:price).inject(&:+) || 0
  end

  def calculate_total_price
    subtotal = calculate_books_price
    if delivery_service
      shipping = delivery_service.price
    else
      shipping = 0
    end
    self.total_price = subtotal + shipping
    self.save
    self.total_price
  end
end


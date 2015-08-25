class Order < ActiveRecord::Base

  belongs_to :billing_address, class_name: "Address"
  belongs_to :shipping_address, class_name: "Address"
  belongs_to :user
  belongs_to :delivery_service
  belongs_to :credit_card
  has_many :order_items
  validates :user, presence: true

  default_scope { order(created_at: :desc) }

  scope :in_progress, -> { where(state: :in_progress) }
  scope :in_queue, -> { where(state: :in_queue) }
  scope :in_delivery, -> { where(state: :in_delivery) }
  scope :delivered, -> { where(state: :delivered) }

  after_create do
    calculate_total_price
    generate_number
  end

  state_machine :state, initial: :in_progress do
    before_transition :in_progress => :in_queue, do: :generate_number
    before_transition any => :in_delivery, do: :take_books
    after_transition any => :delivered, do: :complete
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
      field :user
      field :total_price
      field :state, :state
    end
    edit do
      configure :state, :state
      configure :completed_date do
        read_only true
      end
      configure :number do
        read_only true
      end
      configure :total_price do
        read_only true
      end
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
    self.delivery_service=nil
    calculate_total_price
  end

  # Decrease books quantity when order sent to custom
  def take_books
    order_items.each do |item|
      item.book.books_in_stock -= item.quantity
      item.book.save
    end
  end

  def books_count
    order_items.map(&:quantity).inject(&:+) || 0
  end

  def merge(order)
    order_book_ids = order.order_items.pluck(:book_id)
    book_ids = order_items.pluck(:book_id)
    same_books_ids = order_book_ids & book_ids

    if same_books_ids.empty?
      order.move_items_to(self)
    else
      order.order_items.each {|item| add_book(item.book, item.quantity) } # Todo: maybe destroy items after reassign?
    end
  end

  def move_items_to(order)
    order_items.update_all(order_id: order.id)
    calculate_total_price && order.calculate_total_price
  end

  # Restore books quantity when order was canceled
  def restore_books
    order_items.each do |item|
      item.book.books_in_stock += item.quantity
      item.book.save
    end
  end

  def add_book(book, quantity=1)
    order_item = self.order_items.where(book: book).first
    if order_item
      order_item.quantity += quantity
    else
      order_item = self.order_items.build(book: book, quantity: quantity)
    end
    order_item.update_price!
    order_item.save

    calculate_total_price
  end

  def calculate_books_price
    order_items.map(&:price).inject(&:+) || 0
  end

  def calculate_total_price
    reload
    subtotal = calculate_books_price
    shipping = delivery_service ? delivery_service.price : 0
    self.total_price = subtotal + shipping
    self.save
    self.total_price
  end

  def complete
    raise StandardError.new("Wrong state, should be 'delivered'.") unless delivered?
    self.completed_date = DateTime.now
    notify_user
  end

  def to_s
    "Order ##{number}"
  end

  alias_method :title, :to_s

  private
  def notify_user
    self.completed_date = DateTime.now
    # todo: need to configure heroku
    # UserMailer.delivered_email(user, self).deliver_later
  end
end


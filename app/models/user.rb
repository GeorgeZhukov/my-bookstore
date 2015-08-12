class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]


  validates :first_name, presence: true
  validates :last_name, presence: true
  has_many :orders
  has_many :ratings
  has_one :wish_list
  belongs_to :billing_address, class_name: "Address"
  belongs_to :shipping_address, class_name: "Address"

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.avatar = auth.info.image
    end
  end

  def self.create_guest
    guest = create(email: "guest_#{Time.now.to_i}#{rand(100)}@example.com", guest: true)
    guest.save!(validate: false)
    guest
  end

  def cart
    self.orders.in_progress.first_or_create
  end

  def avatar_url
    if self.avatar
      self.avatar
    else
      gravatar_id = Digest::MD5.hexdigest(email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=128"
    end
  end

  def get_wish_list
    wish_list || WishList.create(user: self)
  end

  def to_s
    if guest
      "Guest"
    else
      "#{first_name} #{last_name}"
    end

  end

  # def after_database_authentication
  #   self.reassign_data_from_guest
  # end

  def reassign_data_from_guest(guest_id)
    # todo: need to refactor
    guest_user = User.find(guest_id)

    guest_cart = guest_user.cart
    user_cart = self.cart

    if guest_cart.order_items.exists?

      if user_cart.order_items.exists?

        guest_cart_book_ids = guest_cart.order_items.pluck(:book_id)
        user_cart_book_ids = user_cart.order_items.pluck(:book_id)
        same_books_ids = guest_cart_book_ids & user_cart_book_ids

        if same_books_ids.empty?
          guest_cart.order_items.update_all(order_id: user_cart.id)
        else
          guest_cart.order_items.each do |order_item|
            user_cart.add_book(order_item.book, order_item.quantity)
          end
        end

      else
        guest_cart.order_items.update_all(order_id: user_cart.id)
      end

      # Refresh total price
      user_cart.calculate_total_price
    end

    # todo: destroy guest user
  end


  alias_method :name, :to_s
end

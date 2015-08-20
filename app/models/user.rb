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
    guest ? I18n.t("user.guest") : "#{first_name} #{last_name}"
  end

  # def after_database_authentication
  #   self.reassign_data_from_guest
  # end

  def move_orders_to(user)
    # Move current cart
    user.cart.merge(cart)

    # Move other orders
    o = orders.where.not(state: "in_progress")
    o.update_all(user_id: user.id) if o.exists?
  end

  alias_method :name, :to_s


end

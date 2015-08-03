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

  def cart
    return self.orders.in_progress.first_or_create
    s = self.orders.in_progress.count
    if self.orders.in_progress.exists?
      self.orders.in_progress
    else
      order = Order.create(state: :in_progress, user: self)
      q = order.user == self
      i  =5
      return order
    end
  end

  def avatar_url
    if self.avatar
      self.avatar
    else
      gravatar_id = Digest::MD5.hexdigest(email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=128"
    end
  end

end

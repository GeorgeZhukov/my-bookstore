class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  belongs_to :delivery_service
  belongs_to :credit_card
end

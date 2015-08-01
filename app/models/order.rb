class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  belongs_to :delivery_service
end

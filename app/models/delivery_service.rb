class DeliveryService < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :price
end

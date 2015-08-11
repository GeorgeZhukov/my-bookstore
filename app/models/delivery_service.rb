class DeliveryService < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :price

  def to_s
    name
  end
end

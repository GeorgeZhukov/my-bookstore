FactoryGirl.define do
  factory :order_item do
    price { Faker::Commerce.price }
    quantity { Faker::Number.digit }
    association :book, factory: :book
    association :order, factory: :order
  end

end

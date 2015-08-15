FactoryGirl.define do
  factory :order_item do
    price { Faker::Commerce.price }
    quantity 1 #{ Faker::Number.digit }
    book

  end

end

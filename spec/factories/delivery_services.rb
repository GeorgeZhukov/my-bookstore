FactoryGirl.define do
  factory :delivery_service do
    sequence(:name) { |n| "Delivery#{Faker::Lorem.word}#{n}" }
    price { Faker::Commerce.price }
  end

end

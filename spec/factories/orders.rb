FactoryGirl.define do
  factory :order do
    # total_price { Faker::Commerce.price }
    # completed_date { Faker::Date.between(2.days.ago, Date.today) }
    state "in_progress"
    credit_card
    delivery_service
    user
    association :shipping_address, factory: :address
    association :billing_address, factory: :address
  end

end

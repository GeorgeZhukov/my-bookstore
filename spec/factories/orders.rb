FactoryGirl.define do
  factory :order do
    # total_price { Faker::Commerce.price }
    completed_date { Faker::Date.between(2.days.ago, Date.today) }
    state "in_progress"
    association :credit_card, factory: :credit_card
    association :delivery_service, factory: :delivery_service
  end

end

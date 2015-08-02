FactoryGirl.define do
  factory :rating do
    review { Faker::Lorem.sentence }
    number { Faker::Number.between(1, 10) }
    association :book, factory: :book
    association :user, factory: :user
    state "pending"
  end

end

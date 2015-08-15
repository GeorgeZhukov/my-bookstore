FactoryGirl.define do
  factory :rating do
    review { Faker::Lorem.sentence }
    number { Faker::Number.between(1, 10) }
    book
    user
    state "pending"
  end

end

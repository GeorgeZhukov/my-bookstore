FactoryGirl.define do
  factory :book do
    title { Faker::Lorem.word }
    short_description { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price }
    books_in_stock { Faker::Number.number(2) }
    association :author, factory: :author
    association :category, factory: :category
  end

end

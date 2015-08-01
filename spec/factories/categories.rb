FactoryGirl.define do
  factory :category do
    sequence(:title) { |n| "#{Faker::Lorem.word}_#{n}" }
  end

end

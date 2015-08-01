FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password "password"

    factory :admin do
      is_admin true
    end
  end

end

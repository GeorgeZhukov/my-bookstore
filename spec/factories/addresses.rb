FactoryGirl.define do
  factory :address do
    address { Faker::Address.street_address }
    zip_code { Faker::Address.zip_code }
    city { Faker::Address.city }
    phone { Faker::PhoneNumber.cell_phone }
    country "us"
  end

end

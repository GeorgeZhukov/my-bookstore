FactoryGirl.define do
  factory :author do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    biography { Faker::Lorem.paragraph }
    photo Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/images/ayn_rand.jpg')))
  end

end

FactoryGirl.define do
  factory :book do
    title { Faker::Book.title }
    short_description { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price }
    books_in_stock { Faker::Number.between(50, 200) }
    cover Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/images/atlascover.jpg')))
    author
    category
  end

end

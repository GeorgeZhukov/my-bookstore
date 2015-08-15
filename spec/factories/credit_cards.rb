FactoryGirl.define do
  factory :credit_card do
    #number { Faker::Business.credit_card_number }
    number {  CreditCardValidations::Factory.random(:maestro) }
    CVV { Faker::Number.number(3) }
    expiration_month { Faker::Number.between(1, 12) }
    expiration_year { Faker::Date.between(Date.today, Date.today + 10.years).year }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    user
  end

end

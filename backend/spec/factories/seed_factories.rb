FactoryBot.define do
  factory :phone_number do
    phone_number {Faker::PhoneNumber.phone_number}
    contact
  end

  factory :contact do
    website {Faker::Internet.domain_name}
    email {Faker::Internet.email}
    user
  end

  factory :user do
    name {Faker::Name.first_name}
    surname {Faker::Name.last_name}
    image_profile {Faker::LoremFlickr.image("50x50")}
    address {Faker::Address.country}
    dob {Faker::Date.between(30.year.ago, 21.year.ago)}
    about {Faker::VentureBros.quote}
  end
end
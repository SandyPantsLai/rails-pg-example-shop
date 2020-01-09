Faker::Config.locale = 'en'

Spree::Address.create!(
  firstname: Faker::Name.first_name,
  lastname: Faker::Name.last_name,
  address1: Faker::Address.street_address,
  address2: Faker::Address.secondary_address,
  city: Faker::Address.city,
  state: Spree::State.find_by!(name: "New York"),
  zipcode: Faker::Address.zip_code(state_abbreviation: "NY"),
  country: Spree::Country.find_by!(iso3: 'USA'),
  phone: Faker::PhoneNumber.phone_number
)
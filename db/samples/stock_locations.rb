country =  Spree::Country.find_by(iso: 'US')
location = Spree::StockLocation.find_or_create_by!(name: 'Default')
location.update_attributes!(
  address1: '789 Main Street',
  city: 'Anytown',
  zipcode: '12345',
  country: country,
  state: country.states.first,
  active: true
)
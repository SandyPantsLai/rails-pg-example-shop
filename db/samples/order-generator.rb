
Store::Sample.load_sample('address-generator', true)

address = Spree::Address.all.sample

all_products = Spree::Product.all

unless all_products
	Spree::Sample.load_sample('products')
end

products_on_order = []

num_of_line_items = rand(1..10)

num_of_line_items.times do 
	products_on_order << all_products.sample
end

order_total = products_on_order.inject(0) {|sum, x| sum + x.master.price }

order = Spree::Order.where(
  number: (0...8).map { (65 + rand(26)).chr }.join,
  email: Faker::Internet.email,
  billing_address: address,
  shipping_address: address,
).first_or_create! do |order|
  order.item_total = order_total
  order.total = order_total
end

unless order.line_items.any?
	location = Spree::StockLocation.find_or_create_by!(name: 'default')
	products_on_order.each do |product|
		order.line_items.new(
	    variant: product.master,
	    quantity: 1,
	    price: product.master.price
	  ).save!
    stock_item = product.master.stock_items.find_by!(stock_location: location)
    if stock_item.count_on_hand < 1
    	begin
    		stock_item.set_count_on_hand(10)
    		"Stock count on hand increased by 10"
    	rescue PG::TRDeadlockDetected
    		"Skipping add count on hand"
    	end
    end
	end 
end

# create payments based on the totals since they can't be known in YAML (quantities are random)
method = Spree::PaymentMethod.where(name: 'Credit Card', active: true).first

# Hack the current method so we're able to return a gateway without a RAILS_ENV
Spree::Gateway.class_eval do
  def self.current
    Spree::Gateway::Bogus.new
  end
end

# This table was previously called spree_creditcards, and older migrations
# reference it as such. Make it explicit here that this table has been renamed.
Spree::CreditCard.table_name = 'spree_credit_cards'

credit_card = Spree::CreditCard.where(cc_type: 'visa',
                                      month: 12,
                                      year: 2.years.from_now.year,
                                      last_digits: '1111',
                                      name: Faker::Name.name,
                                      gateway_customer_profile_id: 'BGS-#{rand(1000,9999)}').first_or_create!

payment = order.payments.where(amount: BigDecimal(order.total, 4),
                                 source: credit_card.clone,
                                 payment_method: method).first_or_create!

payment.update_columns(state: 'completed', response_code: '12345')
payment.save!
order.store = Spree::Store.default
order.save!

order.next! while !order.can_complete?

order.complete!
order.payment_state = 'paid'
order.shipment_state = 'shipped'
order.save!
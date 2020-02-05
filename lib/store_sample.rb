require 'spree_core'
require 'store/sample'

module StoreSample
  class Engine < Rails::Engine
    engine_name 'store_sample'

    def self.load_initial_samples
      Store::Sample.load_sample('taxonomies')
      Store::Sample.load_sample('taxons')
      Store::Sample.load_sample('properties')
      Spree::Sample.load_sample('shipping_categories')
      Spree::Sample.load_sample('tax_categories')
      Spree::Sample.load_sample('tax_rates')
      Store::Sample.load_sample('products')
      Spree::Sample.load_sample('shipping_methods')
      Spree::Sample.load_sample('payment_methods')
      100.times { Store::Sample.load_sample('order-generator', true) }
    end

    def self.generate_orders(num_of_orders)
      num_of_orders.times do
        Store::Sample.load_sample('order-generator', true)
      end
    end

    def self.generate_promo_code_batches(promo_name, base_code, number_of_codes, per_code_usage_limit)
       worker = BatchPromoCodeCreateWorker.new(promo_name, base_code, number_of_codes, per_code_usage_limit)
       worker.perform
    end
  end
end

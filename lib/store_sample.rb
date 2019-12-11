require 'spree_core'
require 'store/sample'

module StoreSample
  class Engine < Rails::Engine
    engine_name 'store_sample'

    def self.load_samples
      Store::Sample.load_sample('taxonomies')
      Store::Sample.load_sample('taxons')
      Store::Sample.load_sample('products')

      Spree::Sample.load_sample('addresses')
      Spree::Sample.load_sample('payment_methods')
      Spree::Sample.load_sample('shipping_categories')
      Spree::Sample.load_sample('shipping_methods')
      Spree::Sample.load_sample('tax_categories')
      Spree::Sample.load_sample('tax_rates')
    end
  end
end

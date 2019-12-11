require 'spree_core'
require 'store/sample'

module StoreSample
  class Engine < Rails::Engine
    engine_name 'store_sample'

    def self.load_samples
      Store::Sample.load_sample('taxonomies')
      Store::Sample.load_sample('taxons')
    end
  end
end
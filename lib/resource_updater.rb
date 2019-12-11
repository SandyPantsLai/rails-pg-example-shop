class ResourceUpdater
  def self.update_product_related_properties(row_hash, product)
    if row_hash["taxon"] then
      row_hash["taxon"].products << product
    end

    if row_hash["stock"] then
      location = Spree::StockLocation.find_or_create_by!(name: 'default')
      stock_item = product.master.stock_items.find_by!(stock_location: location)
      stock_item.set_count_on_hand(Integer(row_hash["stock"]))
    end

    if row_hash["available_on"] then
    	product.available_on = Time.parse(row_hash["available_on"])
    	product.save!
    	# rescue
    	# 	puts "Invalid date format"
    end
  end
end
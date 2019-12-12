class ResourceUpdater
  def update_product_related_properties(row_hash, product)
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
    end

    ["condition", "num_parts", "set_num", "year"].each do |property|
	    if row_hash[property] then
	    	product.set_property(property, row_hash[property])
	    end
  	end
  end
end
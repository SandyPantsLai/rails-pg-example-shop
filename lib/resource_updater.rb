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

    # Retrieve product image from Rebrickable to create images in Cloudinary and attach to product
    if row_hash["set_num"] and product.master.images.blank? then
      path = File.join Rails.root, 'db', 'samples', 'images', "#{row_hash['set_num']}.jpg"
      
      if Pathname.new(path).exist? then
        product.master.images.create!(attachment: open(path, "rb"))
        puts "attached sample image"
      else
        open(path, "wb") do |file|
          puts "https://cdn.rebrickable.com/media/sets/#{row_hash['set_num']}.jpg"
          file << open("https://cdn.rebrickable.com/media/sets/#{row_hash['set_num']}.jpg").read
          product.master.images.create!(attachment: file)
        end
      end

    end
  end
end
require 'resource_updater'

class ResourceCreator

  def initialize
    @fields_to_exclude_from_create = {
      "Product" => ["taxon", "stock", "available_on"]
    }

    @postcreate_function = {
      "Product" => "update_product_related_properties"
    }
  end

	def create_objects_from_dataframe(df, resource_name)
    model_class = "Spree::#{resource_name.classify}".constantize

    df.each(:row).with_index(2) do |row, row_num|
      row_hash = row.to_h
      created_object = model_class.create!(row_hash.except(*@fields_to_exclude_from_create[resource_name]))
      if created_object and @postcreate_function[resource_name] then
        ResourceUpdater.method(@postcreate_function[resource_name]).call(row_hash, created_object)
      end
      puts "Created object from row #{row_num}"
      rescue ActiveRecord::RecordInvalid => e
        puts "Row #{row_num}: #{e.to_s}\n"


    end
  end

end
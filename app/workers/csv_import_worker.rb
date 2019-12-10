require 'open-uri'

class CsvImportWorker < CsvWorker
  def perform(csv_path, resource_name)
  	@model_class = "Spree::#{resource_name.classify}".constantize
   	csv_text = open(csv_path)
		csv = CSV.parse(csv_text, :headers=>true, :encoding => "UTF-8")
		csv.each.with_index(2) do |row, row_num|
    	row_data = transform_data(resource_name, row.to_h)
      puts "Creating with data from row #{row_num}..."
      puts row_data
      puts @model_class.create!(row_data)
      rescue ActiveRecord::RecordInvalid => e
      	puts "Row #{row_num}: #{e.to_s}"
    end
  end

  def transform_data(resource_name, data)
    fields_with_human_friendly_data = {
      "Product" => ["shipping_category", "tax_category"]
    }

    fields_with_human_friendly_data[resource_name].each do |field|
      if data[field]
        field_class = "Spree::#{field.classify}".constantize
        data[field] = field_class.where(name: data[field]).first_or_create!
      end
    end
    return data
  end

end
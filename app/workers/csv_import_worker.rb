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
        begin
          data[field] = Integer(data[field])
        rescue
          field_class = "Spree::#{field.classify}".constantize
          data[field] = find_or_create_by_name(field_class, data[field])
        end
      end
    end
    return data
  end

  def find_or_create_by_name(field_class, data)
    begin
      field_obj = field_class.find_by!(name: data)
    rescue ActiveRecord::RecordNotFound => e
      puts "#{e.to_s}"
      puts "Creating #{field_class} with name #{data}..."
      field_class.create!({name: data})
      field_obj = field_class.find_by!(name: data)
    end
    return field_obj
  end

end

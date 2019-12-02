require 'open-uri'

class CsvImportWorker < CsvWorker
  def perform(csv_path, resource_name)
  	failed_rows = []
  	model_class = "Spree::#{resource_name.classify}".constantize
   	csv_text = open(csv_path)
		csv = CSV.parse(csv_text, :headers=>true, :encoding => "UTF-8")
		csv.each.with_index(1) do |row, row_num|
    	data = row.to_h
    	data = convert_data(data)
      model_class.create!(data)
      puts data
      rescue ActiveRecord::RecordInvalid => e
      	failed_rows.append({"Row #{row_num}": e.to_s})
      	puts "Already exists"
    end
  end

  def convert_data(data)
	  ["shipping_category", "tax_category"].each do |field|
	  	if data.key?(field)
	  		field_name = "Spree::" + field.camelize
	  		model_class = "Spree::#{field.classify}".constantize
	  		data[field] = model_class.find_by!(name: data[field])
	  	end
	  end
  	return data
  end

end
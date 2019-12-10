require 'daru'
require 'open-uri'

class CsvImportWorker < CsvWorker
  def perform(csv_path, resource_name)
    fields_with_human_friendly_data = {
      "Product" => ["shipping_category", "tax_category"]
    }

  	model_class = "Spree::#{resource_name.classify}".constantize

    df = Daru::DataFrame.from_csv(csv_path)

    fields_with_human_friendly_data[resource_name].each do |field| 
      df.uniq(field)[field].each do |field_data| 
        field_class = "Spree::#{field.classify}".constantize
        df[field].replace_values(field_data,field_class.where(name: field_data).first_or_create!)
      end
    end

    df.each(:row).with_index(2) do |row, row_num|
      @model_class.create!(row.to_h)
      puts "#{model_class} created with data from row #{row_num}...\n"
      rescue ActiveRecord::RecordInvalid => e
        puts "Row #{row_num}: #{e.to_s}\n"
    end
  end

end
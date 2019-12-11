require 'daru'
require 'open-uri'

class CsvImportWorker < CsvWorker
  def perform(csv_path, resource_name)
    fields_to_replace = {
      "Product" => ["shipping_category", "tax_category"]
    }

  	model_class = "Spree::#{resource_name.classify}".constantize

    df = Daru::DataFrame.from_csv(csv_path)
    df = replace_human_friendly_data(df, fields_to_replace[resource_name])

    df.each(:row).with_index(2) do |row, row_num|
      model_class.create!(row.to_h)
      rescue ActiveRecord::RecordInvalid => e
        puts "Row #{row_num}: #{e.to_s}\n"
    end
  end

  def replace_human_friendly_data(df, fields)
    fields.each do |field| 
      df.uniq(field)[field].each do |field_data| 
        field_class = "Spree::#{field.classify}".constantize
        df[field].replace_values(field_data,field_class.where(name: field_data).first_or_create!)
      end
    end
    return df
  end

end

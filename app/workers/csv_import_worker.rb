require 'open-uri'

class CsvImportWorker < CsvWorker
  def perform(csv_path, resource_name)
    fields_to_replace = {
      "Product" => ["shipping_category", "tax_category"]
    }

  	model_class = "Spree::#{resource_name.classify}".constantize

    data_transformer = Spree::Admin::CsvsHelper::DataTransformer.new

    df = data_transformer.replace_human_friendly_data(csv_path, fields_to_replace[resource_name])

    df.each(:row).with_index(2) do |row, row_num|
      model_class.create!(row.to_h)
      rescue ActiveRecord::RecordInvalid => e
        puts "Row #{row_num}: #{e.to_s}\n"
    end
  end
end

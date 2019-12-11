require 'daru'

module Spree::Admin::CsvsHelper
	class DataTransformer
		def replace_human_friendly_data(csv_path, fields_to_replace)
			df = Daru::DataFrame.from_csv(csv_path)
	    fields_to_replace.each do |field| 
	      df.uniq(field)[field].each do |field_data| 
	        field_class = "Spree::#{field.classify}".constantize
	        df[field].replace_values(field_data,field_class.where(name: field_data).first_or_create!)
	      end
	    end
	    return df
	  end
	end
end

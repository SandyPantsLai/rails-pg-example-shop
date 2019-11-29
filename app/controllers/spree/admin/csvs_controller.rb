class Spree::Admin::CsvsController < Spree::Admin::BaseController
  require 'csv'
  def index
  	@importable_resources = ["Product", "Order"]
  end

  def import
    row_data = Array.new
    file_for_import = params[:file]
    model_class = "Spree::#{params[:resource_name].classify}".constantize
    failed_rows = []
    CSV.foreach((file_for_import.path), headers: true, encoding: "UTF-8").with_index(1) do |row, row_num|
    	data = row.to_h
    	data = convert_data(data)
      model_class.create!(data)
      rescue ActiveRecord::RecordInvalid => e
      	failed_rows.append({"Row #{row_num}": e.to_s})
    end

    if failed_rows.length > 0
    	flash[:error] = failed_rows
    else
    	flash[:notice] = "All rows added to db."
    end
    redirect_to admin_products_path
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

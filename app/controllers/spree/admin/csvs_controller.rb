class Spree::Admin::CsvsController < Spree::Admin::BaseController
  require 'csv'
  def index
  end

  def import
    row_data = Array.new
    my_file = params[:file]
    resource_name = "Spree::" + params[:resource_name].camelize
    model_name = resource_name.constantize
    CSV.foreach((my_file.path), headers: true, encoding: "UTF-8") do |row|
    	data = row.to_h
    	data = convert_data(data)
      model_name.create!(data)
    end
    flash[:notice] = "All rows added to db."
    redirect_to admin_products_path
  end

  def convert_data(data)
	  ["shipping_category", "tax_category"].each do |field|
	  	if data.key?(field)
	  		field_name = "Spree::" + field.camelize
	  		model_name = field_name.constantize
	  		data[field] = model_name.find_by!(name: data[field])
	  	end
	  end
  return data
  end
end

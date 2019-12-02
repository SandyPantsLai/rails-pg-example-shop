require 'cloudinary'

class Spree::Admin::CsvsController < Spree::Admin::BaseController

  def index
  	@importable_resources = ["Product", "Order"]
  end

  def upload
  	response = Cloudinary::Uploader.upload(params[:file].path, 
	  :folder => params[:resource_name], :public_id => "uploaded_file", :overwrite => true, 
	  :resource_type => "raw")
	  import(response["secure_url"], params[:resource_name])
  end

  def import(url, resource_name)
    CsvImportWorker.perform_async(url, resource_name)
	  flash[:notice] = "Importing file"
    redirect_to admin_products_path
  end
end

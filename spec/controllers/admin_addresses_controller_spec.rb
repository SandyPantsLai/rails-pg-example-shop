require "rails_helper"
describe Spree::Admin::AddressesController do

  describe "GET #index with authorization" do
	stub_authorization!
    it "responds successfully with an HTTP 200 status code" do
	  @routes = Spree::Core::Engine.routes
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #index without authorization" do
    it "redirects successfully if user is not authorized" do
	  @routes = Spree::Core::Engine.routes
      get :index
      expect(response).to have_http_status(:redirect)
    end
  end

end
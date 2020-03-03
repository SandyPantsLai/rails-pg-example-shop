class ApplicationController < ActionController::Base
	before_action :check_rack_mini_profiler 
	def check_rack_mini_profiler
	  if try_spree_current_user.try(:has_spree_role?, "admin")
		if params[:rmp] 
			Rack::MiniProfiler.authorize_request
		end
	  end
	end
end

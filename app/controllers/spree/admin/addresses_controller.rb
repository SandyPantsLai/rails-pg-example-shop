# frozen_string_literal: true

class Spree::Admin::AddressesController < Spree::Admin::BaseController
    respond_to :html

    def index
      params[:q] ||= {}
      params[:q][:created_since_x_days] ||= 30

      @num_of_days = params[:q][:created_since_x_days].to_i

      @addresses = Spree::Address.where(created_at: (Time.now.midnight - @num_of_days.day)..Time.now)
    end
end
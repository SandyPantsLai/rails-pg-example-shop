# frozen_string_literal: true

class Spree::Admin::AddressesController < Spree::Admin::BaseController
    respond_to :html

    def index
      @addresses = Spree::Address.where(created_at: (Time.now.midnight - 30.day)..Time.now)
    end
end
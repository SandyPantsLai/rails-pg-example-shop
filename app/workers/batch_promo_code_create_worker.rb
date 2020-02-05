BatchPromoCodeCreateWorker = Struct.new(:promo_name, :base_code, :number_of_codes, :per_code_usage_limit) do
  def perform
		promotion = Spree::Promotion.first_or_create!(name: promo_name, per_code_usage_limit: per_code_usage_limit)

		promotion_code_batch = promotion.promotion_code_batches.new(
			base_code: base_code,
			number_of_codes: number_of_codes,
		)

		if promotion.save
		  Spree::PromotionCode::BatchBuilder.new(
        promotion_code_batch
      ).build_promotion_codes
		else
		  logger.warn("Unable to create promotion")
		end
	end
end
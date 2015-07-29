module FeatureHelpers

  def add_products product_codes
    product_codes.each do |product_code|
      basket.add_product product_code
    end
  end

end
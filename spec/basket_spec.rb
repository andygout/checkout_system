require 'basket'
require_relative './features/helpers/features'

include FeatureHelpers

describe Basket do

  context 'Adding products to basket' do

    let(:basket) { Basket.new }

    it 'Single product' do
      basket.add_product '001'
      expect(basket.product_codes).to eq ['001']
    end

    it 'Multiple products' do
      add_products ['001', '002', '003']
      expect(basket.product_codes).to eq ['001', '002', '003']
    end

    it 'Multiple same products' do
      add_products ['001', '001', '001']
      expect(basket.product_codes).to eq ['001', '001', '001']
    end

  end

end
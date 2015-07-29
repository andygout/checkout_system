require 'stock'
require 'basket'
require 'checkout'
require 'promotional_rules'
require_relative 'helpers/features'

include FeatureHelpers

feature 'Processing a basket' do

  let(:stock) { Stock.new }
  let(:basket) { Basket.new }
  let(:promotional_rules) { Promotional_Rules.new }
  let(:checkout) { Checkout.new promotional_rules, stock }

  scenario 'Single product' do
    basket.add_product '001'
    checkout.process_basket basket
    expect(checkout.order.length).to eq 1
    expect(checkout.order['001'][:Name]).to eq 'Lavender heart'
    expect(checkout.order['001'][:Price]).to eq 9.25
    expect(checkout.order['001'][:Quantity]).to eq 1
  end

  scenario 'Multiple products (list number of different products)' do
    add_products ['001', '002', '003']
    checkout.process_basket basket
    expect(checkout.order.length).to eq 3
  end

  scenario 'Multiple products (list product name)' do
    add_products ['001', '002', '003']
    checkout.process_basket basket
    expect(checkout.order['001'][:Name]).to eq 'Lavender heart'
    expect(checkout.order['002'][:Name]).to eq 'Personalised cufflinks'
    expect(checkout.order['003'][:Name]).to eq 'Kids T-shirt'
  end

  scenario 'Multiple products (list product price)' do
    add_products ['001', '002', '003']
    checkout.process_basket basket
    expect(checkout.order['001'][:Price]).to eq 9.25
    expect(checkout.order['002'][:Price]).to eq 45.00
    expect(checkout.order['003'][:Price]).to eq 19.95
  end

  scenario 'Multiple products (list product quantity)' do
    add_products ['001', '002', '003']
    checkout.process_basket basket
    expect(checkout.order['001'][:Quantity]).to eq 1
    expect(checkout.order['002'][:Quantity]).to eq 1
    expect(checkout.order['003'][:Quantity]).to eq 1
  end

  scenario 'Multiple same products' do
    add_products ['001', '001', '001']
    checkout.process_basket basket
    expect(checkout.order.length).to eq 1
    expect(checkout.order['001'][:Name]).to eq 'Lavender heart'
    expect(checkout.order['001'][:Price]).to eq 9.25
    expect(checkout.order['001'][:Quantity]).to eq 3
  end

end

feature 'Calculate (pre-discount) subtotal of an order' do

  let(:stock) { Stock.new }
  let(:basket) { Basket.new }
  let(:promotional_rules) { Promotional_Rules.new }
  let(:checkout) { Checkout.new promotional_rules, stock }

  scenario 'Single product' do
    basket.add_product '001'
    checkout.process_basket basket
    expect(checkout.subtotal).to eq 9.25
  end

  scenario 'Multiple products' do
    add_products ['001', '002', '003']
    checkout.process_basket basket
    expect(checkout.subtotal).to eq 74.20
  end

  scenario 'Multiple same products' do
    add_products ['001', '001', '001']
    checkout.process_basket basket
    expect(checkout.subtotal).to eq 27.75
  end

end

feature 'Calculate discount for an order' do

  let(:stock) { Stock.new }
  let(:basket) { Basket.new }
  let(:promotional_rules) { Promotional_Rules.new }
  let(:checkout) { Checkout.new promotional_rules, stock }

  scenario '2 x Kids T-shirts (no discount)' do
    add_products ['003', '003']
    checkout.process_basket basket
    expect(checkout.discount).to eq 0.00
  end

  scenario '3 x Lavender hearts (£8.50 each when >=2 units purchased)' do
    add_products ['001', '001', '001']
    checkout.process_basket basket
    expect(checkout.discount).to eq 2.25
  end

  scenario '2 x Personalised cufflinks (10% discount on purchases > £60)' do
    add_products ['002', '002']
    checkout.process_basket basket
    expect(checkout.discount).to eq 9.00
  end

  scenario '3 x Lavender hearts; 2 x Personalised cufflinks (both discounts)' do
    add_products ['001', '001', '001', '002', '002']
    checkout.process_basket basket
    expect(checkout.discount).to eq 13.80
  end

end

feature 'Apply discount to an order and give final total' do

  let(:stock) { Stock.new }
  let(:basket) { Basket.new }
  let(:promotional_rules) { Promotional_Rules.new }
  let(:checkout) { Checkout.new promotional_rules, stock }

  scenario '2 x Kids T-shirts (no discount)' do
    add_products ['003', '003']
    checkout.process_basket basket
    expect(checkout.final_total).to eq 39.90
  end

  scenario '3 x Lavender hearts (£8.50 each when >=2 units purchased)' do
    add_products ['001', '001', '001']
    checkout.process_basket basket
    expect(checkout.final_total).to eq 25.50
  end

  scenario '2 x Lavender hearts (£8.50 each when >=2 units purchased); 1 x Kids T-shirts' do
    add_products ['001', '003', '001']
    checkout.process_basket basket
    expect(checkout.final_total).to eq 36.95
  end

  scenario '2 x Personalised cufflinks (10% discount on purchases > £60)' do
    add_products ['002', '002']
    checkout.process_basket basket
    expect(checkout.final_total).to eq 81.00
  end

  scenario '1 x Lavender heart; 1 x Personalised cufflinks; 1 x Kids T-shirts (10% discount on purchases > £60)' do
    add_products ['001', '002', '003']
    checkout.process_basket basket
    expect(checkout.final_total).to eq 66.78
  end

  scenario '3 x Lavender hearts; 2 x Personalised cufflinks (both discounts)' do
    add_products ['001', '001', '001', '002', '002']
    checkout.process_basket basket
    expect(checkout.final_total).to eq 103.95
  end

  scenario '2 x Lavender hearts; 1 x Personalised cufflinks; 1 x Kids T-shirts (both discounts)' do
    add_products ['001', '002', '001', '003']
    checkout.process_basket basket
    expect(checkout.final_total).to eq 73.76
  end

end
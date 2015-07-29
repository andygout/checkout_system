class Checkout

  attr_reader :order

  def initialize promotional_rules, stock
    @promotional_rules = promotional_rules
    @stock = stock
    @order = {}
  end

  def process_basket basket
    basket.product_codes.each { |product_code| scan product_code }
  end

  def scan product_code
    product_details = @stock.products[product_code]
    if @order[product_code]
      self.order[product_code][:Quantity] += 1
    else
      self.order[product_code] = product_details
      self.order[product_code][:Quantity] = 1
    end
  end

  def subtotal
    subtotal = 0
    @order.each { |k, v| subtotal += (v[:Price] * v[:Quantity]) }
    subtotal
  end

  def discount
    @promotional_rules.calculate_discount @order, subtotal
  end

  def final_total
    (subtotal - discount).round(2)
  end

  private

  attr_writer :order

end
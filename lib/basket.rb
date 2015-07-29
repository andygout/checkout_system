class Basket

  attr_reader :product_codes

  def initialize
    @product_codes = []
  end

  def add_product product_code
    self.product_codes << product_code
  end

  private

  attr_writer :product_codes

end
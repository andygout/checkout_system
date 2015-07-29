class Stock

  attr_reader :products

  def initialize
    @products = { '001' => {'Name': 'Lavender heart', 'Price': 9.25 },
                  '002' => {'Name': 'Personalised cufflinks', 'Price': 45.00 },
                  '003' => {'Name': 'Kids T-shirt', 'Price': 19.95 }
                }
  end

  private

  attr_writer :products

end
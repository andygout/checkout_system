class Promotional_Rules

  LH_MIN_UNIT_PURCHASE = 2
  LH_DISCOUNT_PER_UNIT = 0.75
  PER_CENT_DISCOUNT_MIN_PURCHASE = 60
  PER_CENT_DISCOUNT_PERCENTAGE = 10

  def calculate_discount order, subtotal
    discount = 0
    discount += lavender_heart_discount order
    discount += per_cent_discount (subtotal - discount)
    discount
  end

  def lavender_heart_discount order
    if order.has_key?("001")
      order["001"][:Quantity] >= LH_MIN_UNIT_PURCHASE ? order["001"][:Quantity] * LH_DISCOUNT_PER_UNIT : 0
    else
      0
    end
  end

  def per_cent_discount total
    total > PER_CENT_DISCOUNT_MIN_PURCHASE ? calculate_percentage(total, PER_CENT_DISCOUNT_PERCENTAGE) : 0
  end

  def calculate_percentage(total, percentage)
    (total / 100) * percentage
  end

end
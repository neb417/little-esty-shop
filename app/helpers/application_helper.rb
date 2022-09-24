module ApplicationHelper
  def price_convert(integer_price)
    number_to_currency(integer_price / 100.to_d)
  end

  def percentage_convert(percentage)
    percentage.to_f/100
  end
end

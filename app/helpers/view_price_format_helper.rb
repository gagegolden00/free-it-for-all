module ViewPriceFormatHelper
  def format_price(price_in_cents)
    dollars = price_in_cents / 100
    cents = price_in_cents % 100
    sprintf('$%d.%02d', dollars, cents)
  end
end

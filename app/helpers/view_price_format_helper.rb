module ViewPriceFormatHelper
  def format_price(price_in_cents)
    if !price_in_cents.nil?
    dollars = price_in_cents / 100 if price_in_cents
    cents = price_in_cents % 100 if price_in_cents
    sprintf('$%d.%02d', dollars, cents)
    else
      0
    end
  end
end

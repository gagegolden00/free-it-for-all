module ViewPriceFormatHelper
  def format_price(price_in_cents)
    if price_in_cents
      sprintf('%.2f', price_in_cents.to_f / 100)
    end
  end
end


class CurrencyInputFormatService < ApplicationService
  def initialize(currency_input)
    @currency_input = currency_input
  end

  def call
    format_currency_input

    if @currency_output
      OpenStruct.new(success?: true, payload: @currency_output)
    else
      OpenStruct.new(success?: false, payload: nil)
    end
  end

  private

  def format_currency_input
    return unless @currency_input

    if @currency_input =~ /\.\d{2}\z/
      @currency_output = @currency_input.delete('.')

    elsif @currency_input =~ /\.\d\z/
      @currency_output = @currency_input.delete('.') + '0'

    elsif !@currency_input.include?('.')
      @currency_output = @currency_input + '00'

    else
      @currency_output = nil
    end
  end


end


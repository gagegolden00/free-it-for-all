# frozen_string_literal: true
class AlertComponent < ViewComponent::Base
  def initialize(type, message)
    super
    @type = type
    @message = message
    @key = SecureRandom.hex(4)
  end

  def render?
    %w[notice alert].include?(@type)
  end

  private

  def color
    case @type
    when 'notice'
      'blue'
    when 'alert'
      'red'
    end
  end

  # Tailwind Safelist
  # text-blue-800 border-blue-300 bg-blue-50 text-blue-500 ring-blue-400 bg-blue-200
  # text-red-800 border-red-300 bg-red-50 text-red-500 ring-red-400 bg-red-200
end

class AlertComponent::Errors < AlertComponent
  def initialize(resource)
    super(nil, nil)
    @resource = resource
  end

  def render?
    @resource.errors.any?
  end
end

# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  BUTTON_SIZES = {
    small: 'p-1',
    medium: 'p-2',
    large: 'p-4'
  }.freeze

  # scheme, size, block (or full width), align_content, tag , type, request (), disabled (bool),

  def initialize(
    text: 'Hello World!',
    path: '#',
    size: BUTTON_SIZES.fetch(:small)
  )
    super
    @text = text
    @path = path
    @size = size
  end

  def with_icon; end
end

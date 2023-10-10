# frozen_string_literal: true

# DOCUMENTED ARGS FOR CUSTOM BUTTON COMPONENT
# KEY              | VALUE TYPE  | OPTIONS
# -------------------------------------------
# styling_scheme:  | symbol      | Pre-defined in the StylingSchemes module
# function_scheme: | symbol      | Pre-defined in the FunctionSchemes module
# id:              | string      | Text to set the id of the element
# href:            | string      | Text to specify the path if the elemet is a link
# text:            | string      | Text to appear inside the button or link
# extra_classes:   | string      | Extra classes that will override the default styling scheme
# data:            | hash/symbols| Data attributes for javascript & stimulus
# leading_visual:  | hash/symbols| Attributes for the class and style of the leading visual

module SchemeDefinitions
  SIZES = {
    xsmall: 'p-0.25 h-6 w-auto',
    small: 'p-1 h-8 w-auto',
    medium: 'p-2 h-10 w-auto',
    large: 'p-3 h-12 w-auto',
    xlarge: 'p-4 h-16 w-auto'
  }

  BUTTON_TYPES = {
    submit: 'submit',
    button: 'button',
    reset: 'reset'
  }
  DISPLAYS = {
    none: 'none',
    block: 'block',
    flex: 'flex',
    inline_flex: 'inline-flex',
    flex_none: 'flex-none'
  }

  TAGS = {
    a: 'a',
    button: 'button'
  }

  SHAPES = {
    rounded: 'rounded'
  }

  METHODS = {
    get: 'get',
    post: 'post'
  }

  # Pre defined style_schemes
  STYLING_SCHEMES = {
    default: {
      text_color: 'text-slate-400',
      bg_color: nil,
      border: 'border',
      border_color: 'border-slate-400',
      size: SIZES[:small],
      display: DISPLAYS[:inline_flex],
      align_content: 'items-center',
      text_align: 'text-center',
      disabled: nil,
      shape: SHAPES[:rounded],
      hover: 'hover:cursor-pointer hover:bg-slate-400 hover:text-white',
      extra_classes: nil
    },

    primary: {
      text_color: 'text-white',
      bg_color: 'bg-green-500',
      border: 'border',
      border_color: 'border-green-500',
      size: SIZES[:small],
      display: DISPLAYS[:inline_flex],
      align_content: 'items-center',
      text_align: 'text-center',
      disabled: nil,
      shape: SHAPES[:rounded],
      hover: 'hover:bg-green-600 hover:border-green-600 hover:cursor-pointer',
      extra_classes: nil
    },

    secondary: {
      text_color: 'text-gray-800',
      bg_color: 'bg-gray-200',
      border: 'border',
      border_color: 'border-gray-300',
      size: SIZES[:small],
      display: DISPLAYS[:inline_flex],
      align_content: 'items-center',
      text_align: 'text-center',
      disabled: nil,
      shape: SHAPES[:rounded],
      hover: 'hover:bg-gray-300 hover:border-gray-400 hover:cursor-pointer',
      extra_classes: nil
    },

    danger: {
      text_color: 'text-white',
      bg_color: 'bg-red-500',
      border: 'border',
      border_color: 'border-red-500',
      size: SIZES[:small],
      display: DISPLAYS[:inline_flex],
      align_content: 'items-center',
      text_align: 'text-center',
      disabled: nil,
      shape: SHAPES[:rounded],
      hover: 'hover:bg-red-600 hover:border-red-600 hover:cursor-pointer',
      extra_classes: nil
    },

    link: {
      text_color: nil,
      bg_color: nil,
      border: nil,
      border_color: nil,
      size: SIZES[:small],
      display: DISPLAYS[:inline_flex],
      align_content: 'items-center',
      text_align: 'text-center',
      disabled: nil,
      shape: nil,
      hover: 'hover:cursor-pointer',
      extra_classes: nil
    }
  }

  FUNCTION_SCHEMES = {
    submit_button: {
      tag: TAGS[:button],
      type: BUTTON_TYPES[:submit]
    },

    link: {
      tag: TAGS[:a],
      type: BUTTON_TYPES[nil],
    },

    button: {
      tag: TAGS[:button],
      type: BUTTON_TYPES[:button]
    }
  }

end

class ButtonComponent < ViewComponent::Base
  include SchemeDefinitions

  def initialize(
    function_scheme: :submit_button,
    styling_scheme: :default,
    id: '',
    href: '',
    text: '',
    extra_classes: '',
    # sanatize data attributes?
    data: {},
    leading_visual: {},
    trailing_visual: {}
  )
    super
    @function_scheme = FUNCTION_SCHEMES[function_scheme] || FUNCTION_SCHEMES[:submit_button]
    @styling_scheme = STYLING_SCHEMES[styling_scheme] || STYLING_SCHEMES[:default]
    @id = id
    @href = href
    @text = text
    @extra_classes = extra_classes
    @data = data
    @leading_visual = leading_visual
    @trailing_visual = trailing_visual
    build_element
  end

  private

  def build_element
    build_html_element_tag
    build_html_element_type
    build_html_element_style_scheme
    build_html_element_data_attributes
    build_html_element_leading_visual
    build_html_element_trailing_visual
  end

  def build_html_element_tag
    return if @function_scheme[:tag].nil?
    @tag = @function_scheme[:tag]
  end

  def build_html_element_type
    return if @function_scheme[:type].nil?
    @type = @function_scheme[:type]
  end

  def build_html_element_style_scheme
    tailwind_class_array = @styling_scheme.values.reject(&:blank?)
    @class_composition = tailwind_class_array.join(' ') + ' ' + @extra_classes.to_s
  end

  def build_html_element_data_attributes
    return if @data.nil?
    @data_attributes = @data.map do |key, value|
      "data-#{key.to_s.gsub('_', '-')}=#{value.to_s.gsub('_', '-')}"
    end.join(' ')
  end

  def build_html_element_leading_visual
    return if @leading_visual.nil? || @leading_visual.empty?
    @leading_visual_class_attribute_value = @leading_visual[:class] ? "#{@leading_visual[:class]}" : ""
    @leading_visual_style_attribute_value = @leading_visual[:style] ? "#{@leading_visual[:style]}" + " margin-right: auto;": ""
  end

  def build_html_element_trailing_visual
    return if @trailing_visual.nil? || @trailing_visual.empty?
    @trailing_visual_class_attribute_value = @trailing_visual[:class] ? "#{@trailing_visual[:class]}": ""
    @trailing_visual_style_attribute_value = @trailing_visual[:style] ? "#{@trailing_visual[:style]}" + " margin-left: auto;": ""
  end
end

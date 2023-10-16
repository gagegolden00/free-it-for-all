# frozen_string_literal: true

# DOCUMENTED ARGS FOR CUSTOM BUTTON COMPONENT
# KEY              | VALUE TYPE  | OPTIONS
# -------------------------------------------
# styling_scheme:  | symbol      | Pre-defined in the StylingSchemes module
# function_scheme: | symbol      | Pre-defined in the StylingSchemes module
# id:              | string      | Text to set the id of the element
# href:            | string      | Text to specify the path if the elemet is a link
# text:            | string      | Text to appear inside the button or link
# custom_cl:       | string      | Extra classes that will override the default styling scheme
# data:            | hash/symbols| Data attributes for javascript & stimulus
# leading_visual:  | hash/symbols| Attributes for the class and style of the leading visual
# trailing_visual: | hash/symbols| Attributes for the class and style of the trailing visual
# SIZES = {
#   xsmall: 'p-0.25 h-6 w-auto',
#   small: 'p-1 h-8 w-auto',
#   medium: 'p-2 h-10 w-auto',
#   large: 'p-3 h-12 w-auto',
#   xlarge: 'p-4 h-16 w-auto'
# }

# module SchemeDefinitions

#   # Pre defined style_schemes
#   STYLING_SCHEMES = {
#     submit: {
#       text_color: 'text-green-400',
#       bg_color: nil,
#       border: 'border',
#       border_color: 'border-green-400',
#       size: 'p-1 h-8 w-auto',
#       display: "inline-flex",
#       align_content: 'items-center',
#       text_align: 'text-center',
#       disabled: nil,
#       shape: "rounded",
#       hover: 'hover:cursor-pointer hover:bg-green-400 hover:text-white',
#       custom_class: nil
#     },

#     button: {
#       text_color: 'text-slate-400',
#       bg_color: nil,
#       border: 'border',
#       border_color: 'border-slate-400',
#       size: 'p-1 h-8 w-auto',
#       display: "inline-flex",
#       align_content: 'items-center',
#       text_align: 'text-center',
#       disabled: nil,
#       shape: "rounded",
#       hover: 'hover:cursor-pointer hover:bg-slate-400 hover:text-white',
#       custom_class: nil
#     },

#     link: {
#       text_color: nil,
#       bg_color: nil,
#       border: nil,
#       border_color: nil,
#       size: 'p-1 h-8 w-auto',
#       display: 'inline-flex',
#       align_content: 'items-center',
#       text_align: 'text-center',
#       disabled: nil,
#       shape: nil,
#       hover: 'hover:cursor-pointer',
#       custom_class: nil
#     }
#   }

#   FUNCTION_SCHEMES = {
#     submit: {
#       tag: 'button',
#       type: 'submit'
#     },
#     button: {
#       tag: 'button',
#       type: 'button'
#     },
#     link: {
#       tag: 'a',
#       type: nil
#     }
#   }
# end

class StylingScheme
  def initialize
  end
end

class FunctionScheme
  def initialize(tag:, type:)
    tag = tag
    type = type
  end

  def create_function_scheme
    
  end
end

class ButtonComponent < ViewComponent::Base


  def initialize(
    function_scheme: :button,
    styling_scheme: :default,
    id: '',
    href: '',
    text: '',
    custom_class: '',
    data: {},
    leading_visual: {},
    trailing_visual: {}
  )
    @function_scheme = FUNCTION_SCHEMES[function_scheme] || FUNCTION_SCHEMES[:button]
    @styling_scheme = STYLING_SCHEMES[styling_scheme] || STYLING_SCHEMES[:button]
    @id = id
    @href = href
    @text = text
    @custom_class = custom_class
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
    if @custom_class.empty?
      tailwind_class_array = @styling_scheme.values.reject(&:blank?)
      @class_composition = tailwind_class_array.join(' ')
    else
      @class_composition = @custom_class
    end
  end

  def build_html_element_data_attributes
    return if @data.nil?

    @data_attributes = @data.map do |key, value|
      "data-#{key.to_s.gsub('_', '-')}=#{value.to_s.gsub('_', '-')}"
    end.join(' ')
  end

  def build_html_element_leading_visual
    return if @leading_visual.nil? || @leading_visual.empty?

    @leading_visual_class_attribute_value = @leading_visual[:class] ? "#{@leading_visual[:class]}" : ''
    @leading_visual_style_attribute_value = @leading_visual[:style] ? "#{@leading_visual[:style]}" + 'padding-right: 5px;' : ''
  end

  def build_html_element_trailing_visual
    return if @trailing_visual.nil? || @trailing_visual.empty?

    @trailing_visual_class_attribute_value = @trailing_visual[:class] ? "#{@trailing_visual[:class]}" : ''
    @trailing_visual_style_attribute_value = @trailing_visual[:style] ? "#{@trailing_visual[:style]}" + 'padding-left: 5px;' : ''
  end
end


class ButtonComponent::Submit < ButtonComponent
  def initialize(
    function_scheme: :submit,
    styling_scheme: :submit,
    id: '',
    href: '',
    text: 'Submit',
    custom_class: '',
    data: {},
    leading_visual: {},
    trailing_visual: {}
  )
    super(function_scheme: function_scheme,
          styling_scheme: styling_scheme,
          id: id,
          href: href,
          text: text,
          custom_class: custom_class,
          data: data,
          leading_visual: leading_visual,
          trailing_visual: trailing_visual)
  end
end


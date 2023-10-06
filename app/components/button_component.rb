# rubocop:disable Metrics/ParameterLists
# frozen_string_literal: true

# DOCUMENTED ARGS FOR CUSTOM BUTTON COMPONENT
# KEY              | VALUE TYPE | OPTIONS
# ------------------------------------------------
# tag:             | symbol     | :a or :button
# id:              | string     | specifies the id of the button
# type:            | symbol     | :submit, :button, or :reset
# destination:     | string     | this is the request destination for "button" tag it will automatically use a url and "a" tags will use href
# text:            | string     | The text for the button
# scheme:          | symbol     | A predefined styling for the button (creates a tailwind class)
# extra_classes:   | string     | A way to add extra classes or override the classes provided by the scheme
# size:            | symbol     | Pre-defined but can be overriden. Sizes avaliable = :xsmall, :small, :medium, :large, :xlarge
# data:            | hash       | This follows the standard convention for defining data attributes using rails helpers/methods to not cause confusion

# DEFAULT VALUES
# tag: :button
# id: "your-id-here"
# type: :submit
# destination: nil
# text: "Your text here"
# method: :post
# scheme: :default
# size: :small
# extra_classes: "some extra classes here"
# data: {}

## NEW DOCUMENTATION FOR NEW FUNCTIONS ABOVE REFERENCES INITIAL BRANCH 

# This module just predefines schemes and other styles for consistancy.
# Schemes can be overriden with the extra_classes attribute
module SchemeDefinitions
  SIZES = {
    xsmall: 'p-0.25',
    small: 'p-1',
    medium: 'p-2',
    large: 'p-3',
    xlarge: 'p-4'
  }

  BUTTON_TYPES = {
    submit: 'submit',
    button: 'button',
    reset: 'reset',
    button_link: 'button_link',
  }

  DISPLAYS = {
    none: 'none',
    block: 'block',
    flex: 'flex'
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
      bg_color: '',
      border: 'border',
      border_color: 'border-slate-400',
      size: SIZES[:small],
      display: '',
      align_content: 'items-center',
      disabled: '',
      shape: SHAPES[:rounded],
      hover: 'hover:cursor-pointer',
      extra_classes: ''
    },

    primary: {
      text_color: 'text-white',
      bg_color: 'bg-green-500',
      border: 'border',
      border_color: 'border-green-500',
      size: SIZES[:small],
      display: '',
      align_content: 'items-center',
      disabled: '',
      shape: SHAPES[:rounded],
      hover: 'hover:bg-green-600 hover:border-green-600 hover:cursor-pointer',
      extra_classes: ''
    },

    secondary: {
      text_color: 'text-gray-800',
      bg_color: 'bg-gray-200',
      border: 'border',
      border_color: 'border-gray-300',
      size: SIZES[:small],
      display: '',
      align_content: 'items-center',
      disabled: '',
      shape: SHAPES[:rounded],
      hover: 'hover:bg-gray-300 hover:border-gray-400 hover:cursor-pointer',
      extra_classes: ''
    },

    danger: {
      text_color: 'text-white',
      bg_color: 'bg-red-500',
      border: 'border',
      border_color: 'border-red-500',
      size: SIZES[:small],
      display: '',
      align_content: 'items-center',
      disabled: '',
      shape: SHAPES[:rounded],
      hover: 'hover:bg-red-600 hover:border-red-600 hover:cursor-pointer',
      extra_classes: ''
    },

    link: {
      text_color: '',
      bg_color: '',
      border: '',
      border_color: '',
      size: SIZES[:small],
      display: '',
      align_content: 'items-center',
      disabled: '',
      shape: '',
      hover: 'hover:cursor-pointer',
      extra_classes: ''
    }
  }

  FUNCTIONS = {
    submit_button: {
      tag: TAGS[:button],
      type: BUTTON_TYPES[:submit],
      method: METHODS[:post]
    },

    link: {
      tag: TAGS[:a],
      type: BUTTON_TYPES[:button_link],
      method: METHODS[:get]
    }
  }
end

class ButtonComponent < ViewComponent::Base
  include SchemeDefinitions

  # destination is maybe not a great name for the
  def initialize(
    styling_scheme: :default,
    function_scheme: :submit_button, # Provide a default symbol here
    id: 'your-id-here',
    destination: nil,
    text: 'Your text here',
    extra_classes: 'some extra classes here',
    data: {}
  )
    super
    @id = id
    @text = text

    @styling_scheme = STYLING_SCHEMES[styling_scheme] || STYLING_SCHEMES[:default]
    @extra_classes = extra_classes
    @class_composition = build_class_scheme

    @selected_function_scheme = FUNCTIONS[function_scheme] || FUNCTIONS[:submit_button]
    build_function_scheme
    @destination = destination
    @destination_composition = build_destination

    @data = data
    @data_attributes = build_data_attributes

  end

  private

  def build_class_scheme
    tailwind_class_array = @styling_scheme.values.reject(&:blank?).join(' ')
    tailwind_class_array + ' ' + @extra_classes
  end

  def build_function_scheme
    @tag = @selected_function_scheme[:tag]
    @type = "type=#{@selected_function_scheme[:type]}"
    if @selected_function_scheme[:method] == :post
      @method = "formmethod=#{@selected_function_scheme[:method]}"
    elseif @selected_function_scheme[:method] == :get
      @method = "method=#{@selected_function_scheme[:method]}"
    end
  end

  def build_data_attributes
    return if @data.nil?
    @data.map { |key, value| "data-#{key.to_s.gsub('_', '-')}=#{value.to_s.gsub('_', '-')}" }.join(' ')
  end

  def build_destination
    if @selected_function_scheme[:tag] == "a" && !@destination.nil?
      "href=#{@destination}"
    elsif @selected_function_scheme[:tag] == "button" && !@destination.nil?
      "url=#{@destination}"
    end
  end
end

class ButtonComponent < ViewComponent::Base
  def build_html_element_data_attributes
    @data_attributes = @data.map do |key, value|
      "data-#{key.to_s.gsub('_', '-')}=#{value.to_s.gsub('_', '-')}"
    end.join(' ')
  end

  def build_html_element_leading_visual
    @leading_visual_class_attribute_value = @leading_visual[:class] ? "#{@leading_visual[:class]}" : ''
    @leading_visual_style_attribute_value = @leading_visual[:style] ? "#{@leading_visual[:style]}" + 'padding-right: 5px;' : ''
  end

  def build_html_element_trailing_visual
    @trailing_visual_class_attribute_value = @trailing_visual[:class] ? "#{@trailing_visual[:class]}" : ''
    @trailing_visual_style_attribute_value = @trailing_visual[:style] ? "#{@trailing_visual[:style]}" + 'padding-left: 5px;' : ''
  end
end

class ButtonComponent::Submit < ButtonComponent
  def initialize(
    id: '',
    text: 'Hey im a button',
    tailwind_class: 'text-green-400 border border-green-400 p-1 h-8 w-auto inline-flex items-center text-center rounded hover:cursor-pointer hover:bg-green-400 hover:text-white',
    data: {},
    leading_visual: {},
    trailing_visual: {}
    )
    @id = id
    @text = text
    @tailwind_class = tailwind_class
    @data = data
    @leading_visual = leading_visual
    @trailing_visual = trailing_visual
    build_html_element_data_attributes unless @data.nil? || @data.empty?
    build_html_element_leading_visual unless @leading_visual.nil? || @leading_visual.empty?
    build_html_element_trailing_visual unless @trailing_visual.nil? || @trailing_visual.empty?
  end
end

class ButtonComponent::Button < ButtonComponent
  def initialize(id: '', text: '', tailwind_class: '', data: {}, leading_visual: {}, trailing_visual: {})
    @id = id
    @text = text
    @tailwind_class = tailwind_class
    @data = data
    @leading_visual = leading_visual
    @trailing_visual = trailing_visual
    build_html_element_data_attributes unless @data.nil? || @data.empty?
    build_html_element_leading_visual unless @leading_visual.nil? || @leading_visual.empty?
    build_html_element_trailing_visual unless @trailing_visual.nil? || @trailing_visual.empty?
  end
end

class ButtonComponent::Link < ButtonComponent
  def initialize(id: '', href: '', text: '', tailwind_class: '', data: {}, leading_visual: {}, trailing_visual: {})
    @id = id
    @href = href
    @text = text
    @tailwind_class = tailwind_class
    @data = data
    @leading_visual = leading_visual
    @trailing_visual = trailing_visual
    build_html_element_data_attributes unless @data.nil? || @data.empty?
    build_html_element_leading_visual unless @leading_visual.nil? || @leading_visual.empty?
    build_html_element_trailing_visual unless @trailing_visual.nil? || @trailing_visual.empty?
  end
end



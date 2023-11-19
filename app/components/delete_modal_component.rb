class DeleteModalComponent < ViewComponent::Base
  def initialize(resource:, child_resource: nil, attribute: , nested_route: true )
    @resource = resource
    @child_resource = child_resource
    @attribute = attribute
    @nested_route = nested_route
  end

  def render?
    !@resource.nil? && !@attribute.nil?
  end

  def format_name(name)
    formatted_name = name.gsub(/(?<!\A)(?=[A-Z])/, ' ').downcase
    formatted_name.sub(/\A\p{L}/) { |match| match.downcase }
  end

end


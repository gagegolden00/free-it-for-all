class ButtonComponent < ViewComponent::Base
  def initialize(text: "Hello World!", path: "#")
    @text = text
    @path = path
  end
end

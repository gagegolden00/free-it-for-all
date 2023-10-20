# frozen_string_literal: true

require_relative '../test_helper'
require "capybara/minitest"
require 'capybara/rails'


#  NOTES:
#       1) For some reason in the test suite there are single quotes being rendered
#          So I am using a gsub to remove the to remain consistent with what is actuall rendered in lookbook
#          There is a private method for rendereing the component consistantly
#
#       2) I have created a private method for printing expected and actual values to verify what is being checked

class ButtonComponentTest < ViewComponent::TestCase
  # DEFAULT BUTTON TESTS
  test 'default button should have button tag' do
    # To confirm expected and actual results
    print_expected_and_actual('<button></button>', render_component(ButtonComponent.new))
    render_component(ButtonComponent.new())
    assert_selector 'button', count: 1
  end

  # test 'default button should have the attribute type with a value of submit' do
  #   puts render_component(ButtonComponent.new)
  #   assert_selector('button[type="submit"]', wait: 10)
  # end


  # test "default button should have the attribute formmethod with a value of post" do
  #   render_inline(ButtonComponent.new())
  #   assert_select "button[type=submit][formmethod=post]", count: 1
  # end
  #

  private

  def print_expected_and_actual(expected, actual)
    puts "Expected to contain: #{expected}"
    puts "Actual: #{actual}"
  end

  def render_component(component)
    render = render_inline(component).to_html.gsub("'", '')
    doc = Nokogiri::HTML.parse(render)
    button_element = doc.at('button[type=submit]')
    button_element.to_html
  end


end

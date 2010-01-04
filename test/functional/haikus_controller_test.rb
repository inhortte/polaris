require File.dirname(__FILE__) + '/../test_helper'
require 'haikus_controller'

# Re-raise errors caught by the controller.
class HaikusController; def rescue_action(e) raise e end; end

class HaikusControllerTest < Test::Unit::TestCase
  fixtures :haikus

  def setup
    @controller = HaikusController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

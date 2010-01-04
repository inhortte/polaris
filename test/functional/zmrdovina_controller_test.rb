require File.dirname(__FILE__) + '/../test_helper'
require 'zmrdovina_controller'

# Re-raise errors caught by the controller.
class ZmrdovinaController; def rescue_action(e) raise e end; end

class ZmrdovinaControllerTest < Test::Unit::TestCase
  def setup
    @controller = ZmrdovinaController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

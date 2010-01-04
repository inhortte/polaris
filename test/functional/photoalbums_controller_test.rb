require File.dirname(__FILE__) + '/../test_helper'
require 'photoalbums_controller'

# Re-raise errors caught by the controller.
class PhotoalbumsController; def rescue_action(e) raise e end; end

class PhotoalbumsControllerTest < Test::Unit::TestCase
  fixtures :photoalbums

  def setup
    @controller = PhotoalbumsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

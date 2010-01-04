require File.dirname(__FILE__) + '/../test_helper'
require 'lepers_controller'

# Re-raise errors caught by the controller.
class LepersController; def rescue_action(e) raise e end; end

class LepersControllerTest < Test::Unit::TestCase
  fixtures :lepers

  def setup
    @controller = LepersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:lepers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_leper
    old_count = Leper.count
    post :create, :leper => { }
    assert_equal old_count+1, Leper.count
    
    assert_redirected_to leper_path(assigns(:leper))
  end

  def test_should_show_leper
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_leper
    put :update, :id => 1, :leper => { }
    assert_redirected_to leper_path(assigns(:leper))
  end
  
  def test_should_destroy_leper
    old_count = Leper.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Leper.count
    
    assert_redirected_to lepers_path
  end
end

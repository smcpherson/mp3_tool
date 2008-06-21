require File.dirname(__FILE__) + '/../test_helper'
require 'options_controller'

# Re-raise errors caught by the controller.
class OptionsController; def rescue_action(e) raise e end; end

class OptionsControllerTest < Test::Unit::TestCase
  fixtures :options

  def setup
    @controller = OptionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = options(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:options)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:option)
    assert assigns(:option).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:option)
  end

  def test_create
    num_options = Option.count

    post :create, :option => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_options + 1, Option.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:option)
    assert assigns(:option).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Option.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Option.find(@first_id)
    }
  end
end

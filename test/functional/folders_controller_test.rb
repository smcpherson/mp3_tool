require File.dirname(__FILE__) + '/../test_helper'
require 'folders_controller'

# Re-raise errors caught by the controller.
class FoldersController; def rescue_action(e) raise e end; end

class FoldersControllerTest < Test::Unit::TestCase
  fixtures :folders

  def setup
    @controller = FoldersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = folders(:first).id
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

    assert_not_nil assigns(:folders)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:folder)
    assert assigns(:folder).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:folder)
  end

  def test_create
    num_folders = Folder.count

    post :create, :folder => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_folders + 1, Folder.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:folder)
    assert assigns(:folder).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Folder.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Folder.find(@first_id)
    }
  end
end

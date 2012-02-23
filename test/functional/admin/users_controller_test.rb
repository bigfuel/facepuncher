require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)
    @controller = Admin::UsersController.new
  end

  should "get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  should "get new" do
    get :new
    assert_response :success
  end

  should "create user" do
    assert_difference('User.count') do
      post :create, user: @user.attributes
    end

    assert_redirected_to admin_user_path(assigns(:user))
  end

  should "show user" do
    get :show, id: @user.to_param
    assert_response :success
  end

  should "get edit" do
    get :edit, id: @user.to_param
    assert_response :success
  end

  should "update user" do
    put :update, id: @user.to_param, user: @user.attributes
    assert_redirected_to admin_user_path(assigns(:user))
  end

  should "destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.to_param
    end

    assert_redirected_to admin_users_path
  end
end

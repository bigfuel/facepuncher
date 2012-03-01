require 'minitest_helper'

describe Admin::ReleasesController do
  before do
    @release = releases(:one)
  end

  it "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:releases)
  end

  it "should get new" do
    get :new
    assert_response :success
  end

  it "should create release" do
    assert_difference('Release.count') do
      post :create, release: @release.attributes
    end

    assert_redirected_to release_path(assigns(:release))
  end

  it "should show release" do
    get :show, id: @release.to_param
    assert_response :success
  end

  it "should get edit" do
    get :edit, id: @release.to_param
    assert_response :success
  end

  it "should update release" do
    put :update, id: @release.to_param, release: @release.attributes
    assert_redirected_to release_path(assigns(:release))
  end

  it "should destroy release" do
    assert_difference('Release.count', -1) do
      delete :destroy, id: @release.to_param
    end

    assert_redirected_to releases_path
  end
end

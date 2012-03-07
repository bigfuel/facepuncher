require 'minitest_helper'

describe AdminController do
  describe "loaded project" do
    before do
      @project = load_project
    end

    it "set a nil project if it doesn't exist" do
      @project.name = "shamwow"
      @controller = Admin::EventsController.new
      get :index, project_id: @project
      assigns(:project).must_be_nil
    end

    it "load the project" do
      @controller = Admin::EventsController.new
      get :index, project_id: @project
      assigns(:project).must_equal @project
    end
  end

  describe "admin not logged in" do
    it "redirect you to sign in" do
      @controller = Admin::ProjectsController.new
      get :index
      assert_redirected_to new_user_session_url
    end
  end
end
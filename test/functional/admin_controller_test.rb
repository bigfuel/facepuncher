require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  context ":load_project" do
    setup do
      @project = Fabricate(:project, name: "bf_project_test")
      @project.activate
    end

    should "set a nil project if it doesn't exist" do
      @project.name = "shamwow"
      @controller = Admin::EventsController.new
      get :index, project_id: @project.to_param
      assert_nil assigns(:project)
    end

    should "load the project" do
      @controller = Admin::EventsController.new
      get :index, project_id: @project.to_param
      assert_equal @project, assigns(:project)
    end
  end

  context "admin not logged in" do
    should "redirect you to sign in" do
      @controller = Admin::ProjectsController.new
      get :index
      assert_redirected_to new_user_session_url
    end
  end
end
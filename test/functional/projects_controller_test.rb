require 'minitest_helper'

describe ProjectsController do
  describe "loaded project" do
    before do
      @project = Fabricate(:project, name: "fp_test")
      Fabricate(:view_template, path: 'fp_test/index', project: @project)
    end

    it "return a routing error if the project is inactive" do
      lambda { get :show, id: @project }.must_raise ActionController::RoutingError
    end

    it "load the first matching active project" do
      @project.activate
      get :show, id: @project
      @controller_project = assigns(:project)
      assert @controller_project
      assert_equal 'fp_test', @controller_project.name
    end
  end
end
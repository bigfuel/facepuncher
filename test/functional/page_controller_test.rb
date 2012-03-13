require 'minitest_helper'

describe PageController do
  describe "loaded project" do
    before do
      @project = Fabricate(:project, name: "bf_project_test")
      @project.activate
    end

    it "return a routing error if the project is inactive" do
      @project.deactivate
      lambda do
        get :index
      end.must_raise ActionController::RoutingError
    end

    it "load the first matching active project" do
      get :index
      @controller_project = assigns(:project)
      assert @controller_project
      assert_equal 'bf_project_test', @controller_project.name
    end
  end
end
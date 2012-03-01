require 'minitest_helper'

describe PageController do
  describe PageController do
    before do
      @project = Fabricate(:project, name: "page")
      @project.activate
    end

    it "return a routing error if the project is inactive" do
      @project.deactivate
      assert_raise ActionController::RoutingError do
        get :index
      end
    end

    it "load the first matching active project" do
      get :index
      @controller_project = assigns(:project)
      assert @controller_project
      assert_equal 'page', @controller_project.name
    end
  end
end
require 'minitest_helper'

describe ApplicationController do
  describe "#load_project" do
    before do
      @project = Fabricate(:project, name: "page")
      @project.activate
    end

    it "return nil if the project is inactive" do
      @controller = PageController.new
      @project.deactivate
      assert_raise ActionController::RoutingError do
        get :index
      end
      assert_nil assigns(:project)
    end

    it "load the first matching active project" do
      @controller = PageController.new
      get :index
      controller_project = assigns(:project)
      assert_equal @project, controller_project
    end
  end

  it "return a routing error when not_found is called" do
    @controller = PageController.new
    assert_raise ActionController::RoutingError do
      get :index
    end
  end
end
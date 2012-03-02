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
      lambda do
        get :index
      end.must_raise ActionController::RoutingError
      assigns(:project).must_be_nil
    end

    it "load the first matching active project" do
      @controller = PageController.new
      get :index
      controller_project = assigns(:project)
      controller_project.must_equal @project
    end
  end

  it "return a routing error when not_found is called" do
    @controller = PageController.new
    lambda do
      get :index
    end.must_raise ActionController::RoutingError
  end
end
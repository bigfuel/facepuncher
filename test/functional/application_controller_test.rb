require 'minitest_helper'

describe ApplicationController do
  describe "#load_project" do
    before do
      @project = Fabricate(:project, name: "fp_test")
      Fabricate(:view_template, path: 'fp_test/index', project: @project)
    end

    it "return not found if the project is inactive" do
      @controller = Api::PostsController.new
      lambda { get :index, format: :json, project_id: @project }.must_raise ActionController::RoutingError
      assigns(:project).must_be_nil
    end

    it "load active project" do
      @project.activate
      @controller = Api::PostsController.new
      get :index, format: :json, project_id: @project
      controller_project = assigns(:project)
      controller_project.must_equal @project
    end
  end

  it "return a routing error when not_found is called" do
    @controller = ProjectsController.new
    lambda { get :show, id: "" }.must_raise ActionController::RoutingError
  end
end
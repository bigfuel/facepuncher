require 'minitest_helper'

describe PostsController do
  before do
    @project = Fabricate(:project, name: "bf_project_test")
    @project.activate
  end

  describe "on GET to :show" do
    before do
      @post = Fabricate(:post, project: @project)
      @post.approve
      get :show, project_name: @project.name, id: @post.id, format: :json
    end

    it "return post object" do
      assert_response :success
      assert_not_nil assigns(:post)
    end
  end
end
require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @project = Fabricate(:project, name: "bf_project_test")
    @project.activate
  end

  context "on GET to :show" do
    setup do
      @post = Fabricate(:post, project: @project)
      @post.approve
      get :show, project_name: @project.name, id: @post.id, format: :json
    end

    should "return post object" do
      assert_response :success
      assert_not_nil assigns(:post)
    end
  end
end
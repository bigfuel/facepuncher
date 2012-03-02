require 'minitest_helper'

describe PostsController do
  before do
    @project = load_project
  end

  describe "on GET to :index" do
    before do
      posts = [Fabricate.build(:post), Fabricate.build(:post), Fabricate.build(:post)]
      Project.any_instance.stubs(posts: stub(approved: stub(page: posts)))
      get :index, project_name: @project.name, format: :json
    end

    it "returns a list of approved posts" do
      must_respond_with :success
      posts = assigns(:posts)
      posts.wont_be_empty
    end
  end

  describe "on GET to :show" do
      before do
      Project.any_instance.stubs(posts: stub(approved: stub(find: Fabricate.build(:post))))
      get :show, project_name: @project.name, id: "1", format: :json
    end

    it "returns a post object" do
      must_respond_with :success
      post = assigns(:post)
      post.wont_be_nil
    end
  end
end
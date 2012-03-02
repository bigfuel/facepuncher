require 'minitest_helper'

describe PostsController do
  before do
    @project = load_project
  end

  describe "on GET to :index" do
    before do
      posts = []
      3.times do
        posts << Fabricate.attributes_for(:post, project: @project)
      end
      Project.any_instance.stubs(posts: stub(approved: stub(page: posts)))
      get :index, format: :json, project_id: @project
    end

    it "returns a list of approved posts" do
      must_respond_with :success
      posts = assigns(:posts)
      posts.wont_be_empty
    end
  end

  describe "on GET to :index" do
    before do
      Project.any_instance.stubs(posts: stub(approved: stub(find: Fabricate.build(:post, project: @project))))
      get :show, project_id: @project, id: "1", format: :json
    end

    it "returns a post object" do
      must_respond_with :success
      post = assigns(:post)
      post.wont_be_nil
    end
  end
end
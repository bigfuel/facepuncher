require 'minitest_helper'

describe Admin::PostsController do
  before do
    @user = Fabricate(:user)
    sign_in @user
    @project = Fabricate(:project, name: "chevy")
    @project.activate
  end

  describe "on GET to :index" do
    before do
      3.times { @project.posts << Fabricate.build(:post) }
      @project.save!
      @project.posts.init_list!
      @posts = @project.posts
    end

    it "return a list of posts in json format" do
      get :index, project_id: @project.to_param, format: :json
      assert_response :success
      posts = assigns(:posts)
      assert posts
      assert_empty @posts - posts
    end

    it "return a list of posts in html format" do
      get :index, project_id: @project.to_param, format: :html
      assert_response :success
      assert_template :index
      posts = assigns(:posts)
      assert posts
      assert_empty @posts - posts
    end

    it "move a post up by one" do
      post = @posts.last
      put :up, project_id: @project.to_param, id: post.id, format: :json
      assert_response :success
      returned_post = assigns(:post)
      assert returned_post
      assert_equal 2, returned_post.position
    end

    it "move a post down by one" do
      post = @posts.first
      put :down, project_id: @project.to_param, id: post.id, format: :json
      assert_response :success
      returned_post = assigns(:post)
      assert returned_post
      assert_equal 2, returned_post.position
    end

  end

  describe "on PUT to :approve" do
    before do
      @post = Fabricate(:post, project: @project)
    end

    it "set post to approved state" do
      put :approve, project_id: @project.to_param, format: :json, id: @post.id, post: @post.as_json
      assert_response :success
      assert assigns(:post)
      assert :approved?
    end
  end

  describe "on PUT to :deny" do
    before do
      @post = Fabricate(:post, project: @project)
    end

    it "set post to approved state" do
      put :deny, project_id: @project.to_param, format: :json, id: @post.id, post: @post.as_json
      assert_response :success
      assert assigns(:post)
      assert :denied?
    end
  end

  describe "on GET to :new" do
    it "render the new template" do
      get :new, project_id: @project.to_param
      assert_response :success
      assert_template :new
    end
  end

  describe "on GET to :edit" do
    before do
      @post = Fabricate(:post, project: @project)
    end

    it "render the edit template" do
      get :edit, project_id: @project.to_param, id: @post.id
      assert_response :success
      assert_template :edit
    end
  end

  describe "on GET to :show" do
    before do
      @post = Fabricate(:post, project: @project)
    end

    it "return a post in the json format" do
      get :show, project_id: @project.to_param, id: @post.id, format: :json
      assert_response :success
      @post = assigns(:post)
      assert @post
    end

    it "render the show template" do
      get :show, project_id: @project.to_param, id: @post.id, format: :html
      assert_response :success
      assert_template :show
    end
  end

  describe "on POST to :create" do
    before do
      @post = Fabricate.build(:post, title: "All the tests pass party!")
    end

    it "return unprocessable_entity and a json object with validation errors when post is invalid" do
      @post.title = ""
      assert_no_difference('Post.count') do
        post :create, project_id: @project.to_param, format: :json, post: @post.as_json
      end
      assert_response :unprocessable_entity
      assert assigns(:post)
      assert_equal Hash["title" => ["can't be blank"]], json_response
    end

    it "return json object if a post is valid" do
      assert_difference('Post.count') do
        post :create, project_id: @project.to_param, format: :json, post: @post.as_json
      end
      assert_response :success
      assert assigns(:post)
      assert_equal "All the tests pass party!", json_response['title']
    end
  end

  describe "on PUT to :update" do
    before do
      @post = Fabricate(:post, project: @project)
    end

    it "return re-render edit template if update is invalid" do
      @post.title = ""
      assert_no_difference('Post.count') do
        put :update, project_id: @project.to_param, id: @post.id, post: @post.attributes
      end
      assert assigns(:post)
      assert_template :edit
    end

    it "return unprocessable_entity if update is invalid" do
      @post.title = ""
      assert_no_difference('Post.count') do
        put :update, project_id: @project.to_param, format: :json, id: @post.id, post: @post.attributes
      end
      assert_response :unprocessable_entity
      assert assigns(:post)
      assert_equal Hash["title" => ["can't be blank"]], json_response
    end

    it "return json object if a post update is valid" do
      @post.title = "Title Updated"
      assert_no_difference('Post.count') do
        put :update, project_id: @project.to_param, format: :json, id: @post.id, post: @post.as_json
      end
      assert_response :success
      assert assigns(:post)
      assert_equal "Title Updated", json_response['title']
    end

    it "return html if a post update is valid" do
      @post.title = "Title Updated"
      assert_no_difference('Post.count') do
        put :update, project_id: @project.to_param, id: @post.id, post: @post.attributes
      end
      assert_redirected_to admin_project_post_url(@project.to_param)
      assert assigns(:post)
    end
  end

  describe "on DELETE to :destroy" do
    before do
      @post = Fabricate(:post, project: @project)
    end

    it "destroy post and return html" do
      assert_difference('Post.count', -1) do
        delete :destroy, project_id: @project.to_param, id: @post.id, format: :html
      end
      assert_redirected_to admin_project_posts_url(@project.to_param)
    end
    it "destroy post and return json" do
      assert_difference('Post.count', -1) do
        delete :destroy, project_id: @project.to_param, id: @post.id, format: :json
      end
      assert_response :success
      assert assigns(:post)
    end

  end

end

require 'minitest_helper'

describe Admin::VideosController do
  before do
    @user = Fabricate(:user)
    sign_in @user
    @project = Fabricate(:project, name: "chevy")
    @project.activate
  end

  describe "on GET to :index" do
    before do
      @video = Fabricate(:video, project: @project)
    end

    it "return a list of videos" do
      get :index, project_id: @project.to_param
      assert_response :success
      assert assigns(:videos)
    end
  end

  describe "on GET to :new" do
    it "render the new template" do
      get :new, project_id: @project.to_param
      assert_response :success
      assert_template :new
    end
  end

  describe "on POST to :create" do
    it "create a video" do
      assert_difference('Video.count') do
        post :create, project_id: @project.to_param, video: Fabricate(:video, name: "boo")
      end

      video = assigns(:video)
      assert_equal "boo", video.name
      assert_redirected_to admin_project_video_path(@project.to_param, video)
    end
  end

  describe "on GET to :show" do
    before do
      @video = Fabricate(:video, youtube_id: "54321", project: @project)
    end

    it "show a video" do
      get :show, project_id: @project.to_param, id: @video.id
      assert_response :success
      assert_equal "54321", assigns(:video).youtube_id
    end
  end

  describe "on GET to :edit" do
    before do
      @video = Fabricate(:video, project: @project)
    end

    it "render the edit template" do
      get :edit, project_id: @project.to_param, id: @video.id
      assert_response :success
      assert_template :edit
    end
  end

  describe "on PUT to :update" do
    before do
      @video = Fabricate(:video, project: @project)
    end

    it "update a video" do
      put :update, project_id: @project.to_param, id: @video.id, video: @video.attributes.merge({ screencap: fixture_file_upload(Rails.root.join('test', 'support', 'QR.png'), 'image/png') })
      assert_equal "QR.png", assigns(:video).screencap_identifier
      assert_redirected_to admin_project_video_url(@project.to_param, assigns(:video))
    end
  end

  describe "on DELETE to :destroy" do
    before do
      @video = Fabricate(:video, project: @project)
    end

    it "destroy a video" do
      assert_difference('Video.count', -1) do
        delete :destroy, project_id: @project.to_param, id: @video.id
      end

      assert_redirected_to admin_project_videos_url(@project.to_param)
    end
  end
end

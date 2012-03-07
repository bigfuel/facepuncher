require 'minitest_helper'

describe Api::VideosController do
  before do
    @project = load_project
  end

  describe "on GET to :index" do
    before do
      @videos = []
      3.times do
        video = Fabricate(:video, project: @project)
        video.approve
        @videos << video
      end
    end

    it "return a list of approved videos" do
      get :index, format: :json, project_id: @project
      must_respond_with :success
      must_render_template "api/videos/index"
      videos = assigns(:videos)
      (videos - @videos).must_be_empty
    end
  end

  describe "on GET to :show" do
    before do
      @video = Fabricate(:video, project: @project)
      @video.approve
    end

    it "return a video" do
      get :show, format: :json, project_id: @project, id: @video.id
      must_respond_with :success
      must_render_template "api/videos/show"
      video = assigns(:video)
      video.must_equal @video
    end
  end

  describe "on POST to :create" do
    it "with a valid video returns a json object" do
      video = Fabricate.attributes_for(:video, youtube_id: "123456", project: nil)
      video['screencap'] = Rack::Test::UploadedFile.new(Rails.root.join('test', 'support', 'Desktop.jpg').to_s, 'image/jpeg', true)
      post :create, format: :json, project_id: @project, video: video
      must_respond_with :success
      json_response['youtube_id'].must_equal "123456"
    end

    it "with an invalid video returns unprocessable_entity and a json object with validation errors" do
      post :create, format: :json, project_id: @project, video: Video.new
      must_respond_with :unprocessable_entity
      json_response["errors"]["youtube_id"].must_include "can't be blank"
    end
  end
end
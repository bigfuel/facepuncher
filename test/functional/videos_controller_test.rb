require 'minitest_helper'

describe VideosController do
  before do
    @project = load_project
  end

  describe "on POST to :create" do
    before do
      @video = Fabricate.build(:video, youtube_id: "123456")
    end

    it "with a valid video returns a json object" do
      post :create, project_name: @project.name, format: :json, video: @video.as_json
      must_respond_with :success
      json_response['youtube_id'].must_equal "123456"
    end
  end

  describe "on POST to :create with an invalid video" do
    it "returns unprocessable_entity and a json object with validation errors" do
      post :create, project_name: @project.name, format: :json, video: Video.new
      must_respond_with :unprocessable_entity
      json_response["youtube_id"].must_include "can't be blank"
    end
  end
end
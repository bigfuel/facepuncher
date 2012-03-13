require 'minitest_helper'

describe VideosController do
  before do
    @project = load_project
  end

  describe "on POST to :create" do
    it "with a valid video returns a json object" do
      post :create, format: :json, project_id: @project, video: Fabricate.attributes_for(:video, youtube_id: "123456", project: nil)
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
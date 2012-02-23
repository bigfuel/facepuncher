require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  setup do
    @project = Fabricate(:project, name: "chevy")
    @project.activate
  end

  context "on POST to :create" do
    setup do
      @video = Fabricate.build(:video, youtube_id: "123456")
    end

    should "return unprocessable_entity and a json object with validation errors when video is invalid" do
      @video.youtube_id = ""
      assert_no_difference('Video.count') do
        post :create, project_name: "chevy", format: :json, video: @video.as_json
      end
      assert_response :unprocessable_entity
      assert assigns(:video)
      assert_equal Hash["youtube_id" => ["can't be blank"]], json_response
    end

    should "return json object if a video is valid" do
      assert_difference('Video.count') do
        post :create, project_name: "chevy", format: :json, video: @video.as_json
      end
      assert_response :success
      assert assigns(:video)
      assert_equal "123456", json_response['youtube_id']
    end
  end
end
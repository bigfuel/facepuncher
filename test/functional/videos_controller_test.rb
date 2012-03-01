require 'minitest_helper'

describe VideosController do
  before do
    @project = Fabricate(:project, name: "bf_project_test")
    @project.activate
  end

  describe "on POST to :create" do
    before do
      @video = Fabricate.build(:video, youtube_id: "123456")
    end

    # it "return unprocessable_entity and a json object with validation errors when video is invalid" do
    #   @video.youtube_id = ""
    #   assert_no_difference('Video.count') do
    #     post :create, project_name: "bf_project_test", format: :json, video: @video.as_json
    #   end
    #   assert_response :unprocessable_entity
    #   assert assigns(:video)
    #   assert_equal Hash["youtube_id" => ["can't be blank"]], json_response
    # end

    it "return json object if a video is valid" do
      # lambda do
      #   post :create, project_name: "bf_project_test", format: :json, video: @video.as_json
      # end.must_change('Video.count')
      # must_respond_with :success
      # assert assigns(:video)
      # assert_equal "123456", json_response['youtube_id']
    end
  end
end
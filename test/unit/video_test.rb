require "test_helper"

class VideoTest < ActiveSupport::TestCase
  should validate_presence_of(:youtube_id)

  context Video do
    setup do
      @project = Fabricate(:project)
      @video = Fabricate(:video)
    end

    should "start in a pending state" do
      assert @video.pending?
    end

    should "be approved" do
      @video.approve
      assert @video.approved?
    end

    should "be denied" do
      @video.deny
      assert @video.denied?
    end

    should "return cached_results" do
      results = @project.videos.where(state: "approved").order_by([:created_at, :asc]).entries
      assert_equal results, @project.videos.cached_results
    end
  end

  context "videos" do
    setup do
      @pending = Array.new
      @denied = Array.new
      @approved = Array.new

      @pending << Fabricate(:video)

      2.times do
        v = Fabricate(:video)
        v.deny
        @denied << v
      end

      3.times do
        v = Fabricate(:video)
        v.approve
        @approved << v
      end
    end

    should "find all pending videos" do
      videos = Video.pending
      assert_equal 1, videos.count
      assert_empty @pending - videos
    end

    should "find all denied video" do
      videos = Video.denied
      assert_equal 2, videos.count
      assert_empty @denied - videos
    end

    should "find all approved videos" do
      videos = Video.approved
      assert_equal 3, videos.count
      assert_empty @approved - videos
    end
  end
end
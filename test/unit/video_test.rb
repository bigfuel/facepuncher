require "minitest_helper"

describe Video do
  it "should have validations" do
    video = Fabricate.build(:video)

    video.must have_valid(:youtube_id)
    video.wont have_valid(:youtube_id).when(nil)
  end

  describe "A video" do
    before do
      @project = Fabricate(:project)
      @video = Fabricate(:video)
    end

    it "must be valid" do
      @video.must_be :valid?
    end

    it "start in a pending state" do
      @video.must_be :pending?
    end

    it "be approved" do
      @video.approve
      @video.must_be :approved?
    end

    it "be denied" do
      @video.deny
      @video.must_be :denied?
    end
  end

  describe "Videos" do
    before do
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

    it "find all pending videos" do
      (Video.pending.entries - @pending).must_be_empty
    end

    it "find all denied video" do
      (Video.denied.entries - @denied).must_be_empty
    end

    it "find all approved videos" do
      (Video.approved.entries - @approved).must_be_empty
    end
  end
end
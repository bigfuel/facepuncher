require "minitest_helper"

describe Submission do
  it "should have validations" do
    submission = Fabricate.build(:submission)

    submission.must have_valid(:facebook_name)
    submission.wont have_valid(:facebook_name).when(nil)

    submission.must have_valid(:facebook_id)
    submission.wont have_valid(:facebook_id).when(nil)

    submission.must have_valid(:facebook_email)
    submission.wont have_valid(:facebook_email).when(nil)

    submission.must have_valid(:photo)
    submission.wont have_valid(:photo).when(nil)
  end

  describe "A submission" do
    before do
      @project = Fabricate(:project)
      @submission = Fabricate(:submission)
    end

    it "should be valid" do
      @submission.must_be :valid?
    end

    it "starts in a pending state" do
      @submission.must_be :pending?
    end

    it "should be approved" do
      @submission.approve
      @submission.must_be :approved?
    end

    it "should be denied" do
      @submission.deny
      @submission.must_be :denied?
    end
  end

  describe "Submissions" do
    before do
      @pending = Array.new
      @approved = Array.new
      @denied = Array.new

      @pending << Fabricate(:submission)

      2.times do
        s = Fabricate(:submission)
        s.approve
        @approved << s
      end

      3.times do
        s = Fabricate(:submission)
        s.deny
        @denied << s
      end
    end

    it "find all pending submissions" do
      (Submission.pending.entries - @pending).must_be_empty
    end

       it "find all approved submissions" do
      (Submission.approved.entries - @approved).must_be_empty
    end

    it "find all denied submissions" do
      (Submission.denied.entries - @denied).must_be_empty
    end
  end
end
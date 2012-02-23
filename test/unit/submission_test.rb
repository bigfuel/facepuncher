require "test_helper"

class SubmissionTest < ActiveSupport::TestCase
  should validate_presence_of(:facebook_name)
  should validate_presence_of(:facebook_id)
  should validate_presence_of(:facebook_email)
  should validate_presence_of(:photo)

  context Submission do
    setup do
      @project = Fabricate(:project)
      @submission = Fabricate(:submission)
    end

    should "be valid" do
      assert @submission.valid?
    end

    should "start in a pending state" do
      assert @submission.pending?
    end

    should "be submitted" do
      @submission.submit
      assert @submission.submitted?
    end

    should "be approved" do
      @submission.submit
      @submission.approve
      assert @submission.approved?
    end

    should "be denied" do
      @submission.submit
      @submission.deny
      assert @submission.denied?
    end

    should "return cached_results" do
      results = @project.submissions.order_by([:created_at, :asc]).entries
      assert_equal results, @project.submissions.cached_results
    end
  end

  context "Submissions" do
    setup do
      @pending = Array.new
      @submitted = Array.new
      @approved = Array.new
      @denied = Array.new

      @pending << Fabricate(:submission)

      2.times do
        s = Fabricate(:submission)
        s.submit
        @submitted << s
      end

      3.times do
        s = Fabricate(:submission)
        s.submit
        s.approve
        @approved << s
      end

      4.times do
        s = Fabricate(:submission)
        s.submit
        s.deny
        @denied << s
      end
    end

    should "find all pending submissions" do
      submissions = Submission.pending
      assert_equal 1, submissions.count
      assert_empty @pending - submissions
    end

    should "find all submitted submissions" do
      submissions = Submission.submitted
      assert_equal 2, submissions.count
      assert_empty @submitted - submissions
    end

    should "find all approved submissions" do
      submissions = Submission.approved
      assert_equal 3, submissions.count
      assert_empty @approved - submissions
    end

    should "find all denied submissions" do
      submissions = Submission.denied
      assert_equal 4, submissions.count
      assert_empty @denied - submissions
    end
  end
end
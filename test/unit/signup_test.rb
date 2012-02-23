require "test_helper"

class SignupTest < ActiveSupport::TestCase
  should validate_presence_of(:email)
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:zip_code)
  should_not allow_value("blah").for(:email)
  should allow_value("a@b.com").for(:email)

  context Signup do
    setup do
      @project = Fabricate(:project)
      @signup = Fabricate(:signup, project: @project)
    end

    should "be valid" do
      assert @signup.valid?
    end

    should "belong to a project" do
      assert_equal @project, @signup.project
    end

    should "start in a pending state" do
      assert_equal 'pending', @signup.state
    end

    should "be uploaded" do
      @signup.upload
      assert_equal 'uploaded', @signup.state
    end

    should "be complete" do
      @signup.complete
      assert_equal 'completed', @signup.state
    end

    should "do conditional validation based on project" do
      flunk
    end

    should "have a unique email per project" do
      same_project_signup = Fabricate.build(:signup, email: @signup.email, project: @signup.project)
      same_project_signup.save
      refute same_project_signup.valid?
      assert_includes same_project_signup.errors, :email
      assert_includes same_project_signup.errors.messages[:email], "has already been used to sign up."

      different_project = Fabricate(:project)
      different_project_signup = Fabricate.build(:signup, project: different_project, email: @signup.email)
      different_project_signup.save
      assert different_project_signup.valid?
    end

    should "have a valid email format" do
      assert_match /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i, @signup.email
      signup = Fabricate.build(:signup, email: 'whatthefuck')
      signup.save
      refute signup.valid?
      assert_includes signup.errors, :email
      assert_includes signup.errors.messages[:email], "is invalid"
    end

    should "return cached_results" do
      results = @project.signups.order_by([:created_at, :asc]).entries
      assert_equal results, @project.signups.cached_results
    end
  end

  context "Signups" do
    setup do
      @pending = Array.new
      @uploaded = Array.new

      @pending << Fabricate(:signup)

      2.times do
        s = Fabricate(:signup)
        s.upload
        @uploaded << s
      end
    end

    should "find all pending signups" do
      signups = Signup.pending
      assert_equal 1, signups.count
      assert_empty @pending - signups
    end

    should "find all uploaded signups" do
      signups = Signup.uploaded
      assert_equal 2, signups.count
      assert_empty @uploaded - signups
    end
  end
end
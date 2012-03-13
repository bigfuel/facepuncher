require "minitest_helper"

describe Signup do
  it "should have validations" do
    signup = Fabricate.build(:signup)

    signup.must have_valid(:first_name)
    signup.wont have_valid(:first_name).when(nil)

    signup.must have_valid(:last_name)
    signup.wont have_valid(:last_name).when(nil)

    signup.must have_valid(:email)
    signup.wont have_valid(:email).when(nil)
    signup.wont have_valid(:email).when("blah")
    signup.wont have_valid(:email).when("blah@example")
  end

  describe "A signup" do
    before do
      @project = Fabricate(:project)
      @signup = Fabricate(:signup, project: @project)
    end

    it "be valid" do
      @signup.must_be :valid?
    end

    it "belong to a project" do
      @signup.project.must_equal @project
    end

    it "starts in a pending state" do
      @signup.must_be :pending?
    end

    it "should be uploaded" do
      @signup.upload
      @signup.must_be :uploaded?
    end

    it "should be complete" do
      @signup.complete
      @signup.must_be :completed?
    end

    it "do conditional validation based on project" do
      skip
    end

    it "have a unique email per project" do
      same_project_signup = Fabricate.build(:signup, email: @signup.email, project: @signup.project)
      same_project_signup.save
      same_project_signup.wont_be :valid?
      same_project_signup.errors.must_include :email
      same_project_signup.errors.messages[:email].must_include "has already been used to sign up."

      different_project = Fabricate(:project)
      different_project_signup = Fabricate.build(:signup, project: different_project, email: @signup.email)
      different_project_signup.save
      different_project_signup.must_be :valid?
    end

    it "have a valid email format" do
      @signup.email.must_match /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i
      signup = Fabricate.build(:signup, email: 'whatthefuck')
      signup.save
      signup.wont_be :valid?
      signup.errors.must_include :email
      signup.errors.messages[:email].must_include "is invalid"
    end

    it "return cached_results" do
      results = @project.signups.order_by([:created_at, :asc]).entries
      @project.signups.cached_results.must_equal results
    end
  end

  describe "Signups" do
    before do
      @pending = Array.new
      @uploaded = Array.new

      @pending << Fabricate(:signup)

      2.times do
        s = Fabricate(:signup)
        s.upload
        @uploaded << s
      end
    end

    it "should find all pending signups" do
      (Signup.pending.entries - @pending).must_be_empty
    end

    it "should find all uploaded signups" do
      (Signup.pending.uploaded - @uploaded).must_be_empty
    end
  end
end
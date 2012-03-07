require 'minitest_helper'

describe SubmissionsController do
  before do
    @project = load_project
  end

  describe "on POST to :create" do
    it "on invalid submission, return submission with validation errors" do
      post :create, format: :json, project_id: @project, submission: Submission.new
      must_respond_with :unprocessable_entity
      json_response["errors"]["facebook_name"].must_include "can't be blank"
    end

    it "with a valid submission, return the saved submission" do
      submission = Fabricate.attributes_for(:submission, project: nil)
      post :create, format: :json, project_id: @project, submission: submission.as_json
      must_respond_with :success
      json_response['facebook_name'].wont_be_blank
    end
  end
end
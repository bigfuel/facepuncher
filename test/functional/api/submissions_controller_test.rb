require 'minitest_helper'

describe Api::SubmissionsController do
  before do
    @project = load_project
  end

  describe "on GET to :show" do
    before do
      @submission = Fabricate(:submission, project: @project)
      @submission.approve
    end

    it "return a submission" do
      get :show, format: :json, project_id: @project, id: @submission.id
      must_respond_with :success
      must_render_template "api/submissions/show"
      submission = assigns(:submission)
      submission.must_equal @submission
    end
  end

  describe "on POST to :create" do
    it "with a valid submission, return the saved submission" do
      submission = Fabricate.attributes_for(:submission, facebook_id: '310', project: nil)
      submission['photo'] = Rack::Test::UploadedFile.new(Rails.root.join('test', 'support', 'Desktop.jpg').to_s, 'image/jpeg', true)
      post :create, format: :json, project_id: @project, submission: submission
      must_respond_with :success
      json_response['facebook_id'].must_equal '310'
    end

    it "on invalid submission, return submission with validation errors" do
      post :create, format: :json, project_id: @project, submission: Submission.new
      must_respond_with :unprocessable_entity
      json_response["errors"]["facebook_name"].must_include "can't be blank"
    end
  end
end
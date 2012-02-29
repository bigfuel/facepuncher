require 'test_helper'

class SubmissionsControllerTest < ActionController::TestCase
  setup do
    @project = Fabricate(:project, name: 'bf_project_test')
    @project.activate
  end

  context "on POST to :create" do
    should "render new template when submission is invalid" do
      assert_no_difference('Submission.count') do
        post :create, project_name: @project.name
      end
      assert_redirected_to '/500.html'
    end

    should "redirect when submission is valid" do
      submission = Fabricate.build(:submission)
      assert_difference('Submission.count') do
        post :create, project_name: @project.name, submission: submission.attributes.merge({photo: fixture_file_upload(Rails.root.join('test', 'support', 'Desktop.jpg'), 'image/jpg')})
      end
      assert assigns(:submission)
      assert_redirected_to "/chevy?submission_id=#{assigns(:submission).id}"
    end
  end
end
require "minitest_helper"

describe "Admin Submissions Integration Test" do
  before do
    sign_in Fabricate(:user)
    @project = Fabricate(:project, name: "bf_project_test")
  end

  describe "on GET to :index" do
    before do
      @submission = Fabricate(:submission, project: @project, facebook_name: "bf_submission_test")
    end

    it "shows correct url and submission name :html" do
      visit admin_project_submissions_path(@project)
      page.current_url.must_include('/bf_project_test/submissions')
      page.must_have_content "bf_submission_test"
    end

    it "shows correct url and submission name :json" do
      visit admin_project_submissions_path(@project, format: :json)
      page.current_url.must_include('/bf_project_test/submissions.json')
      page.must_have_content "bf_submission_test"
    end
  end

  describe "on GET to :new" do
    before do
      visit new_admin_project_submission_path(@project)
    end

    it "shows the correct url" do
      page.current_url.must_include('/submissions/new')
    end

    it "has form field facebook name" do
      page.must_have_field "submission_facebook_name"
    end

    it "has form field facebook id" do
      page.must_have_field "submission_facebook_id"
    end

    it "has form field facebook email" do
      page.must_have_field "submission_facebook_email"
    end

    it "has form field description" do
      page.must_have_field "submission_description"
    end

    it "has form field photo" do
      page.must_have_field "submission_photo"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :edit" do
    before do
      @submission = Fabricate(:submission, project: @project, facebook_name: "bf_submission_test", facebook_id: "123456789", facebook_email: "submission@test.com")
      visit edit_admin_project_submission_path(@project, @submission)
    end

    it "shows the correct url" do
      page.current_url.must_include('/edit')
    end

    it "has form field with submitted facebook name" do
      page.must_have_field "submission_facebook_name", with: "bf_submission_test"
    end

    it "has form field with submitted facebook last name" do
      page.must_have_field "submission_facebook_id", with: "123456789"
    end

    it "has form field with submitted facebook email" do
      page.must_have_field "submission_facebook_email", with: "submission@test.com"
    end

    it "has form field with submitted photo" do
      page.must_have_xpath("//img[contains(@src,\"Desktop.jpg\")]")
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :show" do
    before do
      @submission = Fabricate(:submission, project: @project, facebook_name: "bf_submission_test", facebook_id: "123456789", facebook_email: "submission@test.com")
    end

    it "shows correct url and project submission info :html" do
      visit admin_project_submission_path(@project, @submission)
      path_id = @submission.id.to_s
      page.current_url.must_include('/submissions/' + path_id)
      page.must_have_content 'bf_submission_test'
      page.must_have_content "123456789"
      page.must_have_content "submission@test.com"
      page.must_have_xpath("//img[contains(@src,\"Desktop.jpg\")]")
    end

    it "shows correct url and project submission info :json" do
      visit admin_project_submission_path(@project, @submission, format: :json)
      path_id = @submission.id.to_s
      page.current_url.must_include('/submissions/' + path_id + '.json')
      page.must_have_content '"facebook_name":"bf_submission_test"'
      page.must_have_content '"facebook_id":"123456789"'
      page.must_have_content '"facebook_email":"submission@test.com"'
      page.must_have_content 'Desktop.jpg'
    end
  end

  describe "on POST to :create" do
    it "sucessfully create a new submission :html" do
      visit new_admin_project_submission_path(@project)
      page.fill_in "submission_facebook_name", with: "bf_submission_test"
      page.fill_in "submission_facebook_email", with: "123456789"
      page.fill_in "submission_facebook_id", with: "submission@test.com"
      page.attach_file("submission_photo", File.join(::Rails.root, ('test/support/Desktop.jpg')))
      page.click_on "Save"
      page.must_have_content "Submission was successfully created."
      page.must_have_content 'bf_submission_test'
      page.must_have_content "123456789"
      page.must_have_content "submission@test.com"
      page.must_have_xpath("//img[contains(@src,\"Desktop.jpg\")]")
    end

    it "sucessfully create a new submission :json" do
      skip
    end

    it "fails to create a new submission" do
      visit new_admin_project_submission_path(@project)
      page.fill_in "submission_facebook_name", with: "bf_submission_test"
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to create a new submission :json" do
      skip
    end
  end

  describe "on PUT to :update" do
    before do
      @submission = Fabricate(:submission, project: @project, facebook_name: "bf_submission_test", facebook_id: "123456789", facebook_email: "submission@test.com")
      visit edit_admin_project_submission_path(@project, @submission)
    end

    it "sucessfully update a submission :html" do
      page.fill_in "submission_facebook_name", with: "new_name"
      page.fill_in "submission_facebook_id", with: "987654321"
      page.fill_in "submission_facebook_email", with: "new_email@new_email.com"
      page.attach_file("submission_photo", File.join(::Rails.root, ('test/support/QR.png')))
      page.click_on "Save"
      page.must_have_content "Submission was successfully updated."
      page.must_have_content "new_name"
      page.must_have_content "987654321"
      page.must_have_content "new_email@new_email.com"
      page.must_have_xpath("//img[contains(@src,\"QR.png\")]")
    end

    it "sucessfully update a submission :json" do
      skip
    end

    it "fails to update a submission" do
      page.fill_in "submission_facebook_name", with: ""
      page.fill_in "submission_facebook_id", with: ""
      page.fill_in "submission_facebook_email", with: ""
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to update a submission :json" do
      skip
    end
  end

  describe "on POST to :delete" do
    before do
      @submission = Fabricate(:submission, project: @project, facebook_name: "bf_submission_test")
    end

    it "sucessfully deletes a submission :html" do
      visit admin_project_submissions_path(@project)
      page.must_have_content "bf_submission_test"
      page.click_on "Delete"
      visit admin_project_submissions_path(@project)
      page.wont_have_content "bf_submission_test"
    end

    it "sucessfully deletes a submission :json" do
      visit admin_project_submissions_path(@project)
      page.must_have_content "bf_submission_test"
      page.driver.delete admin_project_submission_path(@project, @submission, format: :json)
      visit admin_project_submissions_path(@project)
      page.wont_have_content "bf_submission_test"
    end
  end

  describe "on GET submission to :approve" do
    before do
      @submission = Fabricate(:submission, project: @project)
    end

    it "sucessfully approves a project :html" do
      visit admin_project_submission_path(@project, @submission)
      page.must_have_content "pending"
      page.driver.get approve_admin_project_submission_path(@project, @submission)
      visit admin_project_submission_path(@project, @submission)
      page.must_have_content "approved"
    end

    it "sucessfully approves a project :json" do
      visit approve_admin_project_submission_path(@project, @submission, format: :json)
      page.current_url.must_include('/approve.json')
      page.must_have_content '"status":"success"'
    end
  end

  describe "on GET submission to :deny" do
    before do
      @submission = Fabricate(:submission, project: @project)
    end

    it "successfully denies a project :html" do
      visit admin_project_submission_path(@project, @submission)
      page.must_have_content "pending"
      page.driver.get deny_admin_project_submission_path(@project, @submission)
      visit admin_project_submission_path(@project, @submission)
      page.must_have_content "denied"
    end

    it "successfully denies a project :json" do
      visit deny_admin_project_submission_path(@project, @submission, format: :json)
      page.current_url.must_include('/deny.json')
      page.must_have_content '"status":"success"'
    end
  end
end
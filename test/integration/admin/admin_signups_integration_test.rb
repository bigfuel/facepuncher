require "minitest_helper"

describe "Admin Signups Integration Test" do
  before do
    sign_in Fabricate(:user)
    @project = Fabricate(:project, name: "bf_project_test")
  end

  describe "on GET to :index" do
    before do
      @signup = Fabricate(:signup, project: @project, first_name: "Daisy")
    end

    it "shows correct url and signup name :html" do
      visit admin_project_signups_path(@project)
      page.current_url.must_include('/bf_project_test/signups')
      page.must_have_content "Daisy"
    end

    it "shows correct url and signup name :json" do
      visit admin_project_signups_path(@project, format: :json)
      page.current_url.must_include('/bf_project_test/signups.json')
      page.must_have_content "Daisy"
    end
  end

  describe "on GET to :new" do
    before do
      visit new_admin_project_signup_path(@project)
    end

    it "shows the correct url" do
      page.current_url.must_include('/signups/new')
    end

    it "has form field first name" do
      page.must_have_field "signup_first_name"
    end

    it "has form field last name" do
      page.must_have_field "signup_last_name"
    end

    it "has form field address" do
      page.must_have_field "signup_address"
    end

    it "has form field city" do
      page.must_have_field "signup_city"
    end

    it "has form field state" do
      page.must_have_field "signup_state_province"
    end

    it "has form field zip code" do
      page.must_have_field "signup_zip_code"
    end

    it "has form field email" do
      page.must_have_field "signup_email"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :edit" do
    before do
      @signup = Fabricate(:signup, project: @project, first_name: "Daisy", last_name: "Lin", email: "signup@test.com")
      visit edit_admin_project_signup_path(@project, @signup)
    end

    it "shows the correct url" do
      page.current_url.must_include('/edit')
    end

    it "has form field with submitted first name" do
      page.must_have_field "signup_first_name", with: "Daisy"
    end

    it "has form field with submitted last name" do
      page.must_have_field "signup_last_name", with: "Lin"
    end

    it "has form field with submitted email" do
      page.must_have_field "signup_email", with: "signup@test.com"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :show" do
    before do
      @signup = Fabricate(:signup, project: @project, first_name: "Daisy", last_name: "Lin", email: "signup@test.com")
    end

    it "shows correct url and project signup info :html" do
      visit admin_project_signup_path(@project, @signup)
      path_id = @signup.id.to_s
      page.current_url.must_include('/signups/' + path_id)
      page.must_have_content 'Daisy'
      page.must_have_content "Lin"
      page.must_have_content "signup@test.com"
    end

    it "shows correct url and project signup info :json" do
      visit admin_project_signup_path(@project, @signup, format: :json)
      path_id = @signup.id.to_s
      page.current_url.must_include('/signups/' + path_id + '.json')
      page.must_have_content '"first_name":"Daisy"'
      page.must_have_content '"last_name":"Lin"'
      page.must_have_content '"email":"signup@test.com"'
    end
  end

  describe "on POST to :create" do
    it "sucessfully create a new signup :html" do
      visit new_admin_project_signup_path(@project)
      page.fill_in "signup_first_name", with: "Daisy"
      page.fill_in "signup_last_name", with: "Lin"
      page.fill_in "signup_email", with: "signup@test.com"
      page.click_on "Save"
      page.must_have_content "Signup was successfully created."
      page.must_have_content 'Daisy'
      page.must_have_content "Lin"
      page.must_have_content "signup@test.com"
    end

    it "sucessfully create a new signup :json" do
      skip
    end

    it "fails to create a new signup" do
      visit new_admin_project_signup_path(@project)
      page.fill_in "signup_first_name", with: "Daisy"
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to create a new signup :json" do
      skip
    end
  end

  describe "on PUT to :update" do
    before do
      @signup = Fabricate(:signup, project: @project, first_name: "Daisy", last_name: "Lin", email: "signup@test.com")
      visit edit_admin_project_signup_path(@project, @signup)
    end

    it "sucessfully update a signup :html" do
      page.fill_in "signup_first_name", with: "new_name"
      page.fill_in "signup_last_name", with: "new_last_name"
      page.fill_in "signup_email", with: "new_email@new_email.com"
      page.click_on "Save"
      page.must_have_content "Signup was successfully updated."
      page.must_have_content "new_name"
      page.must_have_content "new_last_name"
      page.must_have_content "new_email@new_email.com"
    end

    it "sucessfully update a signup :json" do
      skip
    end

    it "fails to update a signup" do
      page.fill_in "signup_first_name", with: ""
      page.fill_in "signup_last_name", with: ""
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to update a signup :json" do
      skip
    end
  end

  describe "on POST to :delete" do
    before do
      @signup = Fabricate(:signup, project: @project, first_name: "Daisy")
    end

    it "sucessfully deletes a signup :html" do
      visit admin_project_signups_path(@project)
      page.must_have_content "Daisy"
      page.click_on "Delete"
      visit admin_project_signups_path(@project)
      page.wont_have_content "Daisy"
    end

    it "sucessfully deletes a signup :json" do
      visit admin_project_signups_path(@project)
      page.must_have_content "Daisy"
      page.driver.delete admin_project_signup_path(@project, @signup, format: :json)
      visit admin_project_signups_path(@project)
      page.wont_have_content "Daisy"
    end
  end

  describe "on GET to import from :index" do
    it "downloads csv" do
      skip
    end
  end
end
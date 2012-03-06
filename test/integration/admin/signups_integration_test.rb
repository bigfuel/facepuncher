require "minitest_helper"

describe "Signups Integration Test" do
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
      page.current_url.must_include('/new')
    end

    it "has form field first name" do
      page.must_have_field :first_name
    end

    it "has form field last name" do
      page.must_have_field :last_name
    end

    it "has form field address" do
      page.must_have_field :address
    end

    it "has form field city" do
      page.must_have_field :city
    end

    it "has form field state" do
      page.must_have_field :state_province
    end

    it "has form field zip code" do
      page.must_have_field :zip_code
    end

    it "has form field email" do
      page.must_have_field :email
    end

    it "has submit button" do
      page.must_have_button :submit
    end
  end

  describe "on GET to :edit" do
    before do
      @signup = Fabricate(:signup, project: @project, first_name: "Daisy", last_name: "Lin", email: "daisy@asdf.com")
      visit edit_admin_project_signup_path(@project, @signup)
    end

    it "shows the correct url" do
      page.current_url.must_include('/edit')
    end

    it "has form field with first name" do
      page.must_have_field :first_name, with: "Daisy"
    end

    it "has form field with last name" do
      page.must_have_field :last_name, with: "Lin"
    end

    it "has form field with email" do
      page.must_have_field :email, with: "daisy@asdf.com"
    end

    it "has blank submit button" do
      page.must_have_button :submit
    end
  end

  describe "on GET to :show" do
    before do
      @signup = Fabricate(:signup, project: @project, first_name: "Daisy", last_name: "Lin", email: "daisy@asdf.com")
    end

    it "shows correct url and project signup info :html" do
      visit admin_project_signup_path(@project, @signup)
      path_id = @signup.id.to_s
      page.current_url.must_include('/signups/' + path_id)
      page.must_have_content 'Daisy'
      page.must_have_content "Lin"
      page.must_have_content "daisy@asdf.com"
    end

    it "shows correct url and project signup info :json" do
      visit admin_project_signup_path(@project, @signup, format: :json)
      path_id = @signup.id.to_s
      page.current_url.must_include('/signups/' + path_id + '.json')
      page.must_have_content '"first_name":"Daisy"'
      page.must_have_content '"last_name":"Lin"'
      page.must_have_content '"email":"daisy@asdf.com"'
    end
  end

  describe "on POST to :create" do
    it "sucessfully create a new signup :html" do
      visit new_admin_project_signup_path(@project)
      page.fill_in "First name", with: "Daisy"
      page.fill_in "Last name", with: "Lin"
      page.fill_in "Email", with: "daisy@asdf.com"
      page.click_on "Save"
      page.must_have_content "Signup was successfully created."
      page.must_have_content 'Daisy'
      page.must_have_content "Lin"
      page.must_have_content "daisy@asdf.com"
    end

    it "sucessfully create a new signup :json" do
      skip
    end

    it "fails to create a new signup" do
      visit new_admin_project_signup_path(@project)
      page.fill_in "First name", with: "Daisy"
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to create a new signup :json" do
      skip
    end
  end

  describe "on PUT to :update" do
    before do
      @signup = Fabricate(:signup, project: @project, first_name: "Daisy", last_name: "Lin", email: "daisy@asdf.com")
      visit edit_admin_project_signup_path(@project, @signup)
    end

    it "sucessfully update a signup :html" do
      page.fill_in "First name", with: "new_name"
      page.fill_in "Last name", with: "new_last_name"
      page.fill_in "Email", with: "new_email@new_email.com"
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
      page.fill_in "First name", with: ""
      page.fill_in "Last name", with: ""
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
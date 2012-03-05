require "minitest_helper"

describe "Projects Integration Test" do
  before do
    sign_in Fabricate(:user)
  end

  describe "on GET to :index" do
    before do
      @project = Fabricate(:project, name: "bf_project_test")
    end

    it "shows project's name :html" do
      visit admin_projects_path
      page.current_url.must_include('projects')
      page.must_have_content "bf_project_test"
    end

    it "shows project's name :json" do
      visit admin_projects_path(format: :json)
      page.current_url.must_include('json')
      page.must_have_content "bf_project_test"
    end
  end

  describe "on GET to :new" do
    before do
      @project = Fabricate(:project, name: "bf_project_test")
      visit new_admin_project_path(@project)
    end

    it "shows the correct url" do
      page.current_url.must_include('/new')
    end

    it "has form field name" do
      page.must_have_field :name
    end

    it "has form field description" do
      page.must_have_field :description
    end

    it "has form field facebook app id" do
      page.must_have_field :facebook_app_id
    end

    it "has form field facebook app secret" do
      page.must_have_field :facebook_app_secret
    end

    it "has form field google analytics tracking code" do
      page.must_have_field :google_analytics_tracking_code
    end

    it "has form field prodcution url" do
      page.must_have_field :production_url
    end

    it "has form field repo" do
      page.must_have_field :repo
    end

    it "has submit button" do
      page.must_have_button :submit
    end
  end

  describe "on GET to :edit" do
    before do
      @project = Fabricate(:project, name: "bf_project_test")
      visit edit_admin_project_path(@project)
    end

    it "shows the correct url" do
      page.current_url.must_include('/edit')
    end

    it "has form field with project name" do
      page.must_have_field :name, with: "bf_project_test"
    end

    it "has form field with project repo value" do
      page.must_have_field :repo, with: @project.repo
    end

    it "has blank submit button" do
      page.must_have_button :submit
    end
  end

  describe "on GET to :show" do
    before do
      @project = Fabricate(:project, name: "bf_project_test")
    end

    it "shows the correct url" do
      visit admin_project_path(@project)
      page.current_url.must_include('/bf_project_test')
    end

    it "shows project's name and repo :html" do
      visit admin_project_path(@project)
      page.current_url.must_include('bf_project_test')
      page.must_have_content "bf_project_test"
      page.must_have_content @project.repo
    end

    it "shows project's name and repo :json" do
      visit admin_project_path(@project, format: :json)
      page.current_url.must_include('json')
      page.must_have_content "bf_project_test"
      page.must_have_content @project.repo
    end

  end

  describe "on POST to :create" do
    it "sucessfully create a new project :html" do
      visit new_admin_project_path
      page.fill_in "Name", with: "bf_project_test"
      page.fill_in "Repo", with: "git@git.bf_project_test.git"
      page.click_on "Save"
      page.must_have_content "Project was successfully created."
      page.must_have_content "bf_project_test"
      page.must_have_content "git@git.bf_project_test.git"
    end

    it "sucessfully create a new project :json" do
      skip
    end

    it "fails to create a new project" do
      visit new_admin_project_path
      page.fill_in "Name", with: "bf_project_test"
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to create a new project :json" do
      skip
    end
  end

  describe "on PUT to :update" do
    before do
      @project = Fabricate(:project, name: "bf_project_test")
      visit edit_admin_project_path(@project)
    end

    it "sucessfully update a project :html" do
      page.fill_in "Name", with: "new_project_name"
      page.fill_in "Repo", with: "new_project_repo"
      page.click_on "Save"
      page.must_have_content "Project was successfully updated."
      page.must_have_content "new_project_name"
      page.must_have_content "new_project_repo"
    end

    it "sucessfully update a project :json" do
      skip
    end

    it "fails to update a project" do
      page.fill_in "Name", with: ""
      page.fill_in "Repo", with: ""
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to update a project :json" do
      skip
    end
  end

  describe "on POST to :delete" do
    before do
      @project = Fabricate(:project, name: "bf_project_test")
    end

    it "sucessfully deletes a new project :html" do
      visit admin_projects_path
      page.must_have_content "bf_project_test"
      page.click_on "Delete"
      visit admin_projects_path
      page.wont_have_content "bf_project_test"
    end

    it "sucessfully deletes a new project :json" do
      visit admin_projects_path
      page.must_have_content "bf_project_test"
      page.driver.delete admin_project_path(@project, format: :json)
      visit admin_projects_path
      page.wont_have_content "bf_project_test"
    end
  end

  describe "on GET to :activate" do
    before do
      @project = Fabricate(:project, name: "bf_project_test")
    end

    it "sucessfully activates a project :html" do
      visit admin_project_path(@project)
      page.must_have_content "inactive"
      page.driver.get activate_admin_project_path(@project)
      visit admin_project_path(@project)
      page.must_have_content "active"
    end

    it "sucessfully activates a project :json" do
      visit activate_admin_project_path(@project, format: :json)
      page.current_url.must_include('/activate.json')
      page.must_have_content "success"
    end
  end

  describe "on GET to :deactivate" do
    before do
      @project = Fabricate(:project, name: "bf_project_test", state: "active")
    end

    it "sucessfully deactivates a project :html" do
      visit admin_project_path(@project)
      page.must_have_content "active"
      page.driver.get deactivate_admin_project_path(@project)
      visit admin_project_path(@project)
      page.must_have_content "inactive"
    end

    it "sucessfully deactivates a project :json" do
      visit deactivate_admin_project_path(@project, format: :json)
      page.current_url.must_include('/deactivate.json')
      page.must_have_content "success"
    end
  end

  describe "on POST to :queue_deploy" do
    before do
      @project = Fabricate(:project, name: "bf_project_test")
    end

    it "sucessfully queues deploy projects" do
      visit admin_projects_path
      page.driver.post queue_deploy_admin_projects_path(format: :json)
      page.current_url.must_include('/queue_deploy.json')
      page.must_have_content "success"
    end
  end
end
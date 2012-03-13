require "minitest_helper"

describe "Admin Facebook Events Integration Test" do
  before do
    sign_in Fabricate(:user)
    @project = Fabricate(:project, name: "bf_project_test")
  end

  describe "on GET to :index" do
    before do
      @facebook_event = Fabricate(:facebook_event, project: @project, name: "bf_facebook_event_test")
    end

    it "shows correct url and facebook_event name :html" do
      visit admin_project_facebook_events_path(@project)
      page.current_url.must_include('/bf_project_test/facebook_events')
      page.must_have_content "bf_facebook_event_test"
    end

    it "shows correct url and facebook_event name :json" do
      visit admin_project_facebook_events_path(@project, format: :json)
      page.current_url.must_include('/bf_project_test/facebook_events.json')
      page.must_have_content "bf_facebook_event_test"
    end
  end

  describe "on GET to :new" do
    before do
      visit new_admin_project_facebook_event_path(@project)
    end

    it "shows the correct url" do
      page.current_url.must_include('/facebook_events/new')
    end

    it "has form field name" do
      page.must_have_field "facebook_event_name"
    end

    it "has form field url" do
      page.must_have_field "facebook_event_limit", with: "10"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :edit" do
    before do
      @facebook_event = Fabricate(:facebook_event, project: @project, name: "bf_facebook_event_test", limit: 15)
      visit edit_admin_project_facebook_event_path(@project, @facebook_event)
    end

    it "shows the correct url" do
      page.current_url.must_include('/edit')
    end

    it "has form field with submitted name" do
      page.must_have_field "facebook_event_name", with: "bf_facebook_event_test"
    end

    it "has form field with submitted set id" do
      page.must_have_field "facebook_event_limit", with: "15"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :show" do
    before do
      @facebook_event = Fabricate(:facebook_event, project: @project, name: "bf_facebook_event_test", limit: 15)
    end

    it "shows correct facebook_event info :html" do
      visit admin_project_facebook_event_path(@project, @facebook_event)
      path_id = @facebook_event.id.to_s
      page.current_url.must_include('/facebook_events/' + path_id)
      page.must_have_content 'bf_facebook_event_test'
      page.must_have_content "15"
    end

    it "shows correct facebook_event info :json" do
      visit admin_project_facebook_event_path(@project, @facebook_event, format: :json)
      path_id = @facebook_event.id.to_s
      page.current_url.must_include('/facebook_events/' + path_id + '.json')
      page.must_have_content '"name":"bf_facebook_event_test"'
      page.must_have_content '"limit":15'
    end
  end

  describe "on POST to :create" do
    it "sucessfully create a new facebook_event :html" do
      visit new_admin_project_facebook_event_path(@project)
      page.fill_in "facebook_event_name", with: "bf_facebook_event_test"
      page.fill_in "facebook_event_limit", with: "15"
      page.click_on "Save"
      page.must_have_content "Facebook event was successfully created."
      page.must_have_content 'bf_facebook_event_test'
      page.must_have_content "15"
    end

    it "sucessfully create a new facebook_event :json" do
      skip
    end

    it "fails to create a new facebook_event" do
      visit new_admin_project_facebook_event_path(@project)
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to create a new facebook_event :json" do
      skip
    end
  end

  describe "on PUT to :update" do
    before do
      @facebook_event = Fabricate(:facebook_event, project: @project, name: "bf_facebook_event_test", limit: 15)
      visit edit_admin_project_facebook_event_path(@project, @facebook_event)
    end

    it "sucessfully update a facebook_event :html" do
      page.fill_in "facebook_event_name", with: "new_name"
      page.fill_in "facebook_event_limit", with: "26"
      page.click_on "Save"
      page.must_have_content "Facebook event was successfully updated."
      page.must_have_content "26"
    end

    it "sucessfully update a facebook_event :json" do
      skip
    end

    it "fails to update a facebook_event" do
      page.fill_in "facebook_event_name", with: ""
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to update a facebook_event :json" do
      skip
    end
  end

  describe "on POST to :delete" do
    before do
      @facebook_event = Fabricate(:facebook_event, project: @project, name: "bf_facebook_event_test")
    end

    it "sucessfully deletes a facebook_event :html" do
      visit admin_project_facebook_events_path(@project)
      page.must_have_content "bf_facebook_event_test"
      page.click_on "Delete"
      visit admin_project_facebook_events_path(@project)
      page.wont_have_content "bf_facebook_event_test"
    end

    it "sucessfully deletes a facebook_event :json" do
      visit admin_project_facebook_events_path(@project)
      page.must_have_content "bf_facebook_event_test"
      page.driver.delete admin_project_facebook_event_path(@project, @facebook_event, format: :json)
      visit admin_project_facebook_events_path(@project)
      page.wont_have_content "bf_facebook_event_test"
    end
  end
end
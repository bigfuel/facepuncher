require "minitest_helper"

describe "Admin Events Integration Test" do
  before do
    sign_in Fabricate(:user)
    @project = Fabricate(:project, name: "bf_project_test")
  end

  describe "on GET to :index" do
    before do
      location = Fabricate.build(:location, address: "100 m street")
      @event = Fabricate(:event, location: location, project: @project, name: "bf_event_test")
    end

    it "shows correct url and event name :html" do
      visit admin_project_events_path(@project)
      page.current_url.must_include('/bf_project_test/events')
      page.must_have_content "bf_event_test"
      page.must_have_content "100 m street"
    end

    it "shows correct url and event name :json" do
      visit admin_project_events_path(@project, format: :json)
      page.current_url.must_include('/bf_project_test/events.json')
      page.must_have_content "bf_event_test"
      page.must_have_content "100 m street"
    end
  end

  describe "on GET to :new" do
    before do
      visit new_admin_project_event_path(@project)
    end

    it "shows the correct url" do
      page.current_url.must_include('/events/new')
    end

    it "has form field name" do
      page.must_have_field "event_name"
    end

    it "has form field type" do
      page.must_have_field "event_type"
    end

    it "has form field start date" do
      page.must_have_field "event_start_date"
    end

    it "has form field end date" do
      page.must_have_field "event_end_date"
    end

    it "has form field url" do
      page.must_have_field "event_url"
    end

    it "has location form field name" do
      page.must_have_field "event_location_attributes_name"
    end

    it "has location form field address" do
      page.must_have_field "location_address"
    end

    it "has location form field latitude" do
      page.must_have_field "location_latitude"
    end

    it "has location form field longitude" do
      page.must_have_field "location_longitude"
    end

    it "has submit link" do
      page.must_have_link "submit-event"
    end
  end

  describe "on GET to :edit" do
    before do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project, name: "bf_event_test", start_date: "03/11/11 04:00 am")
      visit edit_admin_project_event_path(@project, @event)
    end

    it "shows the correct url" do
      page.current_url.must_include('/edit')
    end

    it "has form field with submitted name" do
      page.must_have_field "event_name", with: "bf_event_test"
    end

    it "has form field with submitted start date" do
      page.must_have_field "event_start_date", with: "2003-11-11 04:00:00 AM"
    end

    it "has submit link" do
      page.must_have_link "submit-event"
    end
  end

  describe "on GET to :show" do
    before do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project, name: "bf_event_test", start_date: "11/11/03 04:00 am")
    end

    it "shows correct url and project event info :html" do
      visit admin_project_event_path(@project, @event)
      path_id = @event.id.to_s
      page.current_url.must_include('/events/' + path_id)
      page.must_have_content 'bf_event_test'
      page.must_have_content "11/03/11 04:00 am"
    end

    it "shows correct url and project event info :json" do
      visit admin_project_event_path(@project, @event, format: :json)
      path_id = @event.id.to_s
      page.current_url.must_include('/events/' + path_id + '.json')
      page.must_have_content '"name":"bf_event_test"'
      page.must_have_content '"start_date":"Thu Nov 03, 2011 04:00 AM"'
    end
  end

  describe "on POST to :create" do
    it "sucessfully create a new event :html" do
      skip "Save button is a link and requires javascript"
      # visit new_admin_project_event_path(@project)
      # page.fill_in "event_name", with: "bf_event_test"
      # page.fill_in "event_start_date", with: "11/11/03 04:00 am"
      # page.fill_in "event_location_attributes_name", with: "location123"
      # page.fill_in "location_address", with: "123 street"
      # page.fill_in "location_latitude", with: 40.742264
      # page.fill_in "location_longitude", with: -73.9913408
      # page.click_on "Save"
      # page.must_have_content "Event was successfully created."
      # page.must_have_content 'bf_event_test'
      # page.must_have_content "location123"
      # page.must_have_content "40.742264"
    end

    it "sucessfully create a new event :json" do
      skip
    end

    it "fails to create a new event" do
      skip "Save button is a link and requires javascript"
      # visit new_admin_project_event_path(@project)
      # page.fill_in "Name", with: "bf_event_test"
      # page.click_on "Save"
      # page.must_have_content "prohibited this project from being saved"
    end

    it "fails to create a new event :json" do
      skip
    end
  end

  describe "on PUT to :update" do
    before do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project, name: "bf_event_test", url: "http://newurl.com")
      visit edit_admin_project_event_path(@project, @event)
    end

    it "sucessfully update a event :html" do
      skip "Save button is a link and requires javascript"
      # page.fill_in "event_name", with: "new_name"
      # page.fill_in "event_url", with: "http://newurl.com"
      # page.fill_in "event_location_attributes_name", with: "100 mott street, new york"
      # page.click_on "Save"
      # page.must_have_content "Event was successfully updated."
      # page.must_have_content "new_name"
      # page.must_have_content "http://newurl.com"
      # page.must_have_content "100 mott street, new york"
    end

    it "sucessfully update a event :json" do
      skip
    end

    it "fails to update a event" do
      skip "Save button is a link and requires javascript"
      # page.fill_in "event_name", with: ""
      # page.click_on "Save"
      # page.save_and_open_page
      # page.must_have_content "prohibited this project from being saved"
    end

    it "fails to update a event :json" do
      skip
    end
  end

  describe "on POST to :delete" do
    before do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project, name: "bf_event_test")
    end

    it "sucessfully deletes a event :html" do
      visit admin_project_events_path(@project)
      page.must_have_content "bf_event_test"
      page.click_on "Delete"
      visit admin_project_events_path(@project)
      page.wont_have_content "bf_event_test"
    end

    it "sucessfully deletes a event :json" do
      visit admin_project_events_path(@project)
      page.must_have_content "bf_event_test"
      page.driver.delete admin_project_event_path(@project, @event, format: :json)
      visit admin_project_events_path(@project)
      page.wont_have_content "bf_event_test"
    end
  end

  describe "on GET event to :approve" do
    before do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project)
    end

    it "sucessfully approves a project :html" do
      visit admin_project_event_path(@project, @event)
      page.must_have_content "pending"
      page.driver.get approve_admin_project_event_path(@project, @event)
      visit admin_project_event_path(@project, @event)
      page.must_have_content "approved"
    end

    it "sucessfully approves a project :json" do
      visit approve_admin_project_event_path(@project, @event, format: :json)
      page.current_url.must_include('/approve.json')
      page.must_have_content '"status":"success"'
    end
  end

  describe "on GET event to :deny" do
    before do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project)
    end

    it "successfully denies a project :html" do
      visit admin_project_event_path(@project, @event)
      page.must_have_content "pending"
      page.driver.get deny_admin_project_event_path(@project, @event)
      visit admin_project_event_path(@project, @event)
      page.must_have_content "denied"
    end

    it "successfully denies a project :json" do
      visit deny_admin_project_event_path(@project, @event, format: :json)
      page.current_url.must_include('/deny.json')
      page.must_have_content '"status":"success"'
    end
  end

#   describe "on GET to import from :index" do
#     it "downloads csv" do
#       skip
#     end
#   end
end
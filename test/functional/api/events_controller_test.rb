require 'minitest_helper'

describe Api::EventsController do
  before do
    @project = load_project
  end

  describe "on GET to :index" do
    before do
      @events = []
      3.times do
        event = Fabricate(:event, project: @project)
        event.approve
        @events << event
      end
      event = Fabricate(:event, type: 'good', project: @project)
      event.approve
      @events << event
    end

    it "return a list of approved events" do
      get :index, format: :json, project_id: @project
      must_respond_with :success
      must_render_template "api/events/index"
      events = assigns(:events)
      (events - @events).must_be_empty
    end

    it "return a list of good approved events when type good=1 is specified" do
      get :index, format: :json, project_id: @project, type: { good: 1 }
      must_respond_with :success
      must_render_template "api/events/index"
      events = assigns(:events)
      events.wont_be_empty
    end
  end

  describe "on GET to :show" do
    before do
      event = Fabricate(:event, project: @project)
      event.approve
      @event = event
    end

    it "return an event" do
      get :show, format: :json, project_id: @project, id: @event.id
      must_respond_with :success
      must_render_template "api/events/show"
      event = assigns(:event)
      event.must_equal @event
    end
  end

  describe "on POST to :create" do
    it "with a valid event returns a json object" do
      @event = Fabricate.attributes_for(:event, name: "All the tests pass party!")
      @location = Fabricate.attributes_for(:location)
      post :create, format: :json, project_id: @project, event: @event.as_json, "event[location_attributes]" => @location
      must_respond_with :success
      json_response['name'].must_equal "All the tests pass party!"
    end

    it "with an invalid event responds with :unprocessable_entity and returns a json object with validation errors" do
      post :create, format: :json, project_id: @project, event: Event.new
      must_respond_with :unprocessable_entity
      json_response["errors"]["name"].must_include "can't be blank"
    end
  end
end
require 'minitest_helper'

describe EventsController do
  before do
    @project = load_project
  end

  describe "on GET to :index" do
    before do
      events = []
      3.times do
        events << Fabricate.build(:event, project: @project)
      end
      events.stubs(any_in: [Fabricate.build(:event)])
      Project.any_instance.stubs(events: stub(future: stub(approved: events)))
    end

    it "return a list of approved events" do
      get :index, format: :json, project_id: @project
      must_respond_with :success
      events = assigns(:events)
      events.wont_be_empty
    end

    it "return a list of good approved events when type good=1 is specified" do
      get :index, format: :json, project_id: @project, type: { good: 1 }
      must_respond_with :success
      events = assigns(:events)
      events.wont_be_empty
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
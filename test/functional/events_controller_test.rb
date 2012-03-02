require 'minitest_helper'

describe EventsController do
  before do
    @project = load_project
  end

  describe "on GET to :index" do
    before do
      events = [Fabricate.build(:event), Fabricate.build(:event), Fabricate.build(:event)]
      events.stubs(any_in: [Fabricate.build(:event)])
      Project.any_instance.stubs(events: stub(future: stub(approved: events)))
    end

    it "return a list of approved events" do
      get :index, project_name: @project.name, format: :json
      must_respond_with :success
      events = assigns(:events)
      events.wont_be_empty
    end

    it "return a list of good approved events when type good=1 is specified" do
      get :index, project_name: @project.name, format: :json, type: { good: 1 }
      must_respond_with :success
      events = assigns(:events)
      events.wont_be_empty
    end
  end

  describe "on POST to :create" do
    before do
      @event = Fabricate.build(:event, name: "All the tests pass party!", location: Fabricate.build(:location))
    end

    it "with a valid event returns a json object" do
      post :create, project_name: @project.name, format: :json, event: @event.as_json
      must_respond_with :success
      json_response['name'].must_equal "All the tests pass party!"
    end
  end

  describe "on POST to :create with an invalid event" do
    it "responds with :unprocessable_entity and returns a json object with validation errors" do
      post :create, project_name: @project.name, format: :json, event: Event.new
      must_respond_with :unprocessable_entity
      json_response["name"].must_include "can't be blank"
    end
  end
end
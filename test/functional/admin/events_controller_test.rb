require 'minitest_helper'

describe Admin::EventsController do
  before do
    @user = Fabricate(:user)
    sign_in @user
    @project = Fabricate(:project, name: "bf_project_test")
    @project.activate
  end

  describe "on GET to :index" do
    before do
      3.times do
        location = Fabricate.build(:location)
        @project.events << Fabricate.build(:event, location: location, project: @project)
      end
      @project.save!
      @project.events.init_list!
      @events = @project.events
    end

    it "return a list of events in json format" do
      get :index, project_id: @project, format: :json
      assert_response :success
      events = assigns(:events)
      assert events
      assert_empty @events - events
    end

    it "return a list of events in html format" do
      get :index, project_id: @project, format: :html
      assert_response :success
      assert_template :index
      events = assigns(:events)
      assert events
      assert_empty @events - events
    end
  end

  describe "on PUT to :approve" do
    before do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project)
    end

    it "set event to approved state" do
      put :approve, project_id: @project, format: :json, id: @event.id, event: @event.as_json
      assert_response :success
      assert assigns(:event)
      assert :approved?
    end
  end

  describe "on PUT to :deny" do
    before do
      @event = Fabricate(:event, project: @project)
    end

    it "set event to approved state" do
      put :deny, project_id: @project, format: :json, id: @event.id, event: @event.as_json
      assert_response :success
      assert assigns(:event)
      assert :denied?
    end
  end

  describe "on GET to :new" do
    it "render the new template" do
      get :new, project_id: @project
      assert_response :success
      assert_template :new
    end
  end

  describe "on GET to :edit" do
    before do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project)
    end

    it "render the edit event" do
      get :edit, project_id: @project, id: @event.id
      assert_response :success
      assert_template :edit
    end
  end

  describe "on GET to :show" do
    before do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project)
    end

    it "return a event in the json format" do
      get :show, project_id: @project, id: @event.id, format: :json
      assert_response :success
      @event = assigns(:event)
      assert @event
    end

    it "render the show template" do
      get :show, project_id: @project, id: @event.id, format: :html
      assert_response :success
      assert_template :show
    end
  end

  describe "on POST to :create" do
    before do
      location = Fabricate.build(:location)
      @event = Fabricate.build(:event, location: location, project: @project)
    end

    it "return unprocessable_entity and a json object with validation errors when event is invalid" do
      @event.name = ""
      assert_no_difference('Event.count') do
        post :create, project_id: @project, format: :json, event: @event.as_json
      end
      assert_response :unprocessable_entity
      assert assigns(:event)
      assert_equal Hash["name" => ["can't be blank"]], json_response
    end

    it "return json object if a event is valid" do
      assert_difference('Event.count') do
        post :create, project_id: @project, format: :json, event: @event.as_json
      end
      assert_response :success
      assert assigns(:event)
    end
  end

  describe "on PUT to :update" do
    before do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project)
    end

    it "return re-render edit template if update is invalid" do
      @event.name = ""
      assert_no_difference('Event.count') do
        put :update, project_id: @project, id: @event.id, event: @event.attributes
      end
      assert assigns(:event)
      assert_template :edit
    end

    it "return unprocessable_entity if update is invalid" do
      @event.name = ""
      assert_no_difference('Event.count') do
        put :update, project_id: @project, format: :json, id: @event.id, event: @event.attributes
      end
      assert_response :unprocessable_entity
      assert assigns(:event)
      json_response["errors"]["name"].must_include "can't be blank"
    end

    it "return json object if a event update is valid" do
      @event.name = "Name Updated"
      assert_no_difference('Event.count') do
        put :update, project_id: @project, format: :json, id: @event.id, event: @event.as_json
      end
      assert_response :success
      assert assigns(:event)
      json_response["name"].must_include "Name Updated"
    end

    it "return html if a event update is valid" do
      @event.name = "Name Updated"
      assert_no_difference('Event.count') do
        put :update, project_id: @project, id: @event.id, event: @event.attributes
      end
      assert_redirected_to admin_project_event_url(@project)
      assert assigns(:event)
    end
  end

  describe "on DELETE to :destroy" do
    before do
      @event = Fabricate(:event, project: @project)
    end

    it "destroy event and return html" do
      assert_difference('Event.count', -1) do
        delete :destroy, project_id: @project, id: @event.id, format: :html
      end
      assert_redirected_to admin_project_events_url(@project)
    end
    it "destroy event and return json" do
      assert_difference('Event.count', -1) do
        delete :destroy, project_id: @project, id: @event.id, format: :json
      end
      assert_response :success
      assert assigns(:event)
    end
  end
end

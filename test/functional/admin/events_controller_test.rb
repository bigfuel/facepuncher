require 'test_helper'

class Admin::EventsControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)
    sign_in @user
    @project = Fabricate(:project, name: "bf_project_test")
    @project.activate
  end

  context "on GET to :index" do
    setup do
      3.times do
        location = Fabricate.build(:location)
        @project.events << Fabricate.build(:event, location: location, project: @project)
      end
      @project.save!
      @project.events.init_list!
      @events = @project.events
    end

    should "return a list of events in json format" do
      get :index, project_id: @project.to_param, format: :json
      assert_response :success
      events = assigns(:events)
      assert events
      assert_empty @events - events
    end

    should "return a list of events in html format" do
      get :index, project_id: @project.to_param, format: :html
      assert_response :success
      assert_template :index
      events = assigns(:events)
      assert events
      assert_empty @events - events
    end
  end

  context "on PUT to :approve" do
    setup do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project)
    end

    should "set event to approved state" do
      put :approve, project_id: @project.to_param, format: :json, id: @event.id, event: @event.as_json
      assert_response :success
      assert assigns(:event)
      assert :approved?
    end
  end

  context "on PUT to :deny" do
    setup do
      @event = Fabricate(:event, project: @project)
    end

    should "set event to approved state" do
      put :deny, project_id: @project.to_param, format: :json, id: @event.id, event: @event.as_json
      assert_response :success
      assert assigns(:event)
      assert :denied?
    end
  end

  context "on GET to :new" do
    should "render the new template" do
      get :new, project_id: @project.to_param
      assert_response :success
      assert_template :new
    end
  end

  context "on GET to :edit" do
    setup do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project)
    end

    should "render the edit event" do
      get :edit, project_id: @project.to_param, id: @event.id
      assert_response :success
      assert_template :edit
    end
  end

  context "on GET to :show" do
    setup do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project)
    end

    should "return a event in the json format" do
      get :show, project_id: @project.to_param, id: @event.id, format: :json
      assert_response :success
      @event = assigns(:event)
      assert @event
    end

    should "render the show template" do
      get :show, project_id: @project.to_param, id: @event.id, format: :html
      assert_response :success
      assert_template :show
    end
  end

  context "on POST to :create" do
    setup do
      location = Fabricate.build(:location)
      @event = Fabricate.build(:event, location: location, project: @project)
    end

    should "return unprocessable_entity and a json object with validation errors when event is invalid" do
      @event.name = ""
      assert_no_difference('Event.count') do
        post :create, project_id: @project.to_param, format: :json, event: @event.as_json
      end
      assert_response :unprocessable_entity
      assert assigns(:event)
      assert_equal Hash["name" => ["can't be blank"]], json_response
    end

    should "return json object if a event is valid" do
      assert_difference('Event.count') do
        post :create, project_id: @project.to_param, format: :json, event: @event.as_json
      end
      assert_response :success
      assert assigns(:event)
    end
  end

  context "on PUT to :update" do
    setup do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location, project: @project)
    end

    should "return re-render edit template if update is invalid" do
      @event.name = ""
      assert_no_difference('Event.count') do
        put :update, project_id: @project.to_param, id: @event.id, event: @event.attributes
      end
      assert assigns(:event)
      assert_template :edit
    end

    should "return unprocessable_entity if update is invalid" do
      @event.name = ""
      assert_no_difference('Event.count') do
        put :update, project_id: @project.to_param, format: :json, id: @event.id, event: @event.attributes
      end
      assert_response :unprocessable_entity
      assert assigns(:event)
      assert_equal Hash["name" => ["can't be blank"]], json_response
    end

    should "return json object if a event update is valid" do
      @event.name = "Name Updated"
      assert_no_difference('Event.count') do
        put :update, project_id: @project.to_param, format: :json, id: @event.id, event: @event.as_json
      end
      assert_response :success
      assert assigns(:event)
      assert_equal "Name Updated", json_response['name']
    end

    should "return html if a event update is valid" do
      @event.name = "Name Updated"
      assert_no_difference('Event.count') do
        put :update, project_id: @project.to_param, id: @event.id, event: @event.attributes
      end
      assert_redirected_to admin_project_event_url(@project.to_param)
      assert assigns(:event)
    end
  end

  context "on DELETE to :destroy" do
    setup do
      @event = Fabricate(:event, project: @project)
    end

    should "destroy event and return html" do
      assert_difference('Event.count', -1) do
        delete :destroy, project_id: @project.to_param, id: @event.id, format: :html
      end
      assert_redirected_to admin_project_events_url(@project.to_param)
    end
    should "destroy event and return json" do
      assert_difference('Event.count', -1) do
        delete :destroy, project_id: @project.to_param, id: @event.id, format: :json
      end
      assert_response :success
      assert assigns(:event)
    end
  end
end

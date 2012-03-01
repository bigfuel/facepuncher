require 'minitest_helper'

describe EventsController do
  before do
    @project = Fabricate(:project, name: "bf_project_test")
    @project.activate
  end

  describe "on GET to :index" do
    before do
      @pending = Array.new
      @denied = Array.new
      @approved = Array.new
      @good = Array.new

      @pending << Fabricate(:event, project: @project, type: "good")

      e = Fabricate(:event, project: @project, type: "bad")
      e.deny
      @denied << e

      e = Fabricate(:event, project: @project, type: "good")
      e.approve
      @good << e
      @approved << e
      e = Fabricate(:event, project: @project, type: "bad")
      e.approve
      @approved << e
    end

    it "return a list of approved events" do
      get :index, project_name: "bf_project_test", format: :json
      assert_response :success
      @events = assigns(:events)
      assert @events
      assert_equal @approved, @events
    end

    it "return a list of good approved events when type good=1 is specified" do
      get :index, project_name: "bf_project_test", format: :json, type: Hash["good" => 1]
      assert_response :success
      @events = assigns(:events)
      assert @events
      assert_equal @good, @events
    end
  end

  describe "on POST to :create" do
    before do
      @event = Fabricate.build(:event, name: "All the tests pass party!")
    end

    it "return unprocessable_entity and a json object with validation errors when event is invalid" do
      @event.name = ""
      assert_no_difference('Event.count') do
        post :create, project_name: "bf_project_test", format: :json, event: @event.as_json
      end
      assert_response :unprocessable_entity
      assert assigns(:event)
      assert_equal Hash["name" => ["can't be blank"]], json_response
    end

    it "return json object if a evente is valid" do
      assert_difference('Event.count') do
        post :create, project_name: "bf_project_test", format: :json, event: @event.as_json
      end
      assert_response :success
      assert assigns(:event)
      assert_equal "All the tests pass party!", json_response['name']
    end
  end
end
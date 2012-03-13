require 'minitest_helper'

describe SignupsController do
  before do
    @project = load_project
  end

  describe "on POST to :create" do
    before do
      @signup = Fabricate.build(:signup, email: "tech@bigfuel.com", first_name: "Big", last_name: "Fuel", address: "40 W 23rd St.", city: "New York", state_province: "NY", zip_code: "10010")
    end

    it "return unprocessable_entity and a json object with validation errors when signup is invalid" do
      @signup.email = ""
      assert_no_difference('Signup.count') do
        post :create, project_id: @project, format: :json, signup: @signup.as_json
      end
      must_respond_with :unprocessable_entity
      assigns(:signup)
      assert_equal Hash["email" => ["can't be blank"]], json_response
    end

    it "set state as complete if signup is flagged with opt_out" do
      @signup[:opt_out] = true
      post :create, project_id: @project, format: :json, signup: @signup.as_json
      must_respond_with :success
      assigns(:signup)
      assert_equal "completed", json_response['state']
    end

    it "return json object if a signup is valid" do
      assert_difference('Signup.count') do
        post :create, project_id: @project, format: :json, signup: @signup.as_json
      end
      assert_response :success
      assert assigns(:signup)
      assert_equal "tech@bigfuel.com", json_response['email']
      assert_equal "Big", json_response['first_name']
      assert_equal "Fuel", json_response['last_name']
      assert_equal "40 W 23rd St.", json_response['address']
      assert_equal "NY", json_response['state_province']
      assert_equal "10010", json_response['zip_code']
    end
  end
end
require 'test_helper'

class SignupsControllerTest < ActionController::TestCase
  setup do
    @project = Fabricate(:project, name: "chevy")
    @project.activate
  end

  context "on POST to :create" do
    setup do
      @signup = Fabricate.build(:signup, email: "tech@bigfuel.com", first_name: "Big", last_name: "Fuel", address: "40 W 23rd St.", city: "New York", state_province: "NY", zip_code: "10010")
    end

    should "return unprocessable_entity and a json object with validation errors when signup is invalid" do
      @signup.email = ""
      assert_no_difference('Signup.count') do
        post :create, project_name: "chevy", format: :json, signup: @signup.as_json
      end
      assert_response :unprocessable_entity
      assert assigns(:signup)
      assert_equal Hash["email" => ["can't be blank"]], json_response
    end

    should "set state as complete if signup is flagged with opt_out" do
      @signup[:opt_out] = true
      assert_difference('Signup.count') do
        post :create, project_name: "chevy", format: :json, signup: @signup.as_json
      end
      assert_response :success
      assert assigns(:signup)
      assert_equal "completed", json_response['state']
    end

    should "return json object if a signup is valid" do
      assert_difference('Signup.count') do
        post :create, project_name: "chevy", format: :json, signup: @signup.as_json
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
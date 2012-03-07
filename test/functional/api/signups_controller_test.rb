require 'minitest_helper'

describe Api::SignupsController do
  before do
    @project = load_project
  end

  describe "on POST to :create" do
    before do
      @signup = Fabricate.attributes_for(:signup, email: "tech@bigfuel.com", first_name: "Big", last_name: "Fuel", address: "40 W 23rd St.", city: "New York", state_province: "NY", zip_code: "10010", project: nil)
    end

    it "return unprocessable_entity and a json object with validation errors when signup is invalid" do
      @signup[:email] = ""
      lambda do
        post :create, format: :json, project_id: @project, signup: @signup
      end.wont_change('Signup.count')
      must_respond_with :unprocessable_entity
      signup = assigns(:signup)
      json_response["errors"]["email"].must_include "can't be blank"
    end

    it "set state as complete if signup is flagged with opt_out" do
      @signup[:opt_out] = true
      post :create, format: :json, project_id: @project, signup: @signup
      must_respond_with :success
      signup = assigns(:signup)
      json_response['state'].must_equal "completed"
    end

    it "return json object if a signup is valid" do
      lambda do
        post :create, format: :json, project_id: @project, signup: @signup
      end.must_change('Signup.count')
      must_respond_with :success
      signup = assigns(:signup)
      json_response['email'].must_equal "tech@bigfuel.com"
      json_response['first_name'].must_equal "Big"
      json_response['last_name'].must_equal "Fuel"
      json_response['address'].must_equal "40 W 23rd St."
      json_response['state_province'].must_equal "NY"
      json_response['zip_code'].must_equal "10010"
    end
  end
end
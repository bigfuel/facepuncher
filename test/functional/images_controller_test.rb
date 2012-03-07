require 'minitest_helper'

describe ImagesController do
  before do
    @project = load_project
  end

  describe "on POST to :create" do
    it "with an invalid image, will return the image with error validations " do
      post :create, format: :json, project_id: @project, image: Image.new
      must_respond_with :unprocessable_entity
      json_response["errors"]["image"].must_include "can't be blank"
    end

    it "with a valid image will return an image" do
      post :create, format: :json, project_id: @project, image: Fabricate.attributes_for(:image, name: "logo", project: nil)
      image = assigns(:image)
      must_respond_with :success
      json_response['name'].must_equal "logo"
    end
  end
end
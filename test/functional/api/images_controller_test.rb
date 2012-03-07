require 'minitest_helper'

describe Api::ImagesController do
  before do
    @project = load_project
  end

  describe "on GET to :index" do
    before do
      @images = []
      3.times do
        @images << Fabricate(:image, project: @project)
      end
    end

    it "return a list of images" do
      get :index, format: :json, project_id: @project
      must_respond_with :success
      must_render_template "api/images/index"
      images = assigns(:images)
      (images - @images).must_be_empty
    end
  end

  describe "on GET to :show" do
    before do
      @image = Fabricate(:image, project: @project)
    end

    it "return an image" do
      get :show, format: :json, project_id: @project, id: @image.id
      must_respond_with :success
      must_render_template "api/images/show"
      image = assigns(:image)
      image.must_equal @image
    end
  end

  describe "on POST to :create" do
    it "with an invalid image, will return the image with error validations " do
      post :create, format: :json, project_id: @project, image: Image.new
      must_respond_with :unprocessable_entity
      json_response["errors"]["image"].must_include "can't be blank"
    end

    it "with a valid image will return an image" do
      image = Fabricate.attributes_for(:image, name: "logo", project: nil)
      image['image'] = Rack::Test::UploadedFile.new(Rails.root.join('test', 'support', 'Desktop.jpg').to_s, 'image/jpeg', true)
      post :create, format: :json, project_id: @project, image: image
      must_respond_with :success
      json_response['name'].must_equal "logo"
    end
  end
end
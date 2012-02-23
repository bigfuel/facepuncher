require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  setup do
    @project = Fabricate(:project, name: "chevy")
    @project.activate
  end

  context "on POST to :create" do
    setup do
      @image = Fabricate.build(:image, name: "logo")
      @signed_request = "crap"
      @redirect_to = "poop"
    end

    should "return unprocessable_entity and a json object with validation errors when image is invalid" do
      skip
    end

    should "redirect to an error page when image is invalid" do
      @image.image = nil
      assert_no_difference('Image.count') do
        post :create, project_name: "chevy", image: @image, signed_request: @signed_request, redirect_to: @redirect_to
      end
      assert assigns(:image)
      assert_redirected_to "poop?error=true&signed_request=crap"
    end

    should "return json object if a image is valid" do
      skip
    end

    should "redirect with image_id defined when image is valid" do
      assert_difference('Image.count') do
        post :create, project_name: "chevy", image: @image.attributes.merge({ image: fixture_file_upload(Rails.root.join('test', 'support', 'Desktop.jpg'), 'image/jpg') }), signed_request: @signed_request, redirect_to: @redirect_to
      end
      image = assigns(:image)
      assert image
      assert_redirected_to "poop?image_id=#{image.id}&signed_request=crap"
    end
  end
end
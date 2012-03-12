require "minitest_helper"

describe "Admin images Integration Test" do
  before do
    sign_in Fabricate(:user)
    @project = Fabricate(:project, name: "bf_project_test")
  end

  describe "on GET to :index" do
    before do
      @image = Fabricate(:image, project: @project, name: "bf_image_test")
    end

    it "shows correct url and image name :html" do
      visit admin_project_images_path(@project)
      page.current_url.must_include('/bf_project_test/images')
      page.must_have_content "bf_image_test"
    end

    it "shows correct url and image name :json" do
      visit admin_project_images_path(@project, format: :json)
      page.current_url.must_include('/bf_project_test/images.json')
      page.must_have_content "bf_image_test"
    end
  end

  describe "on GET to :new" do
    before do
      visit new_admin_project_image_path(@project)
    end

    it "shows the correct url" do
      page.current_url.must_include('/images/new')
    end

    it "has form field name" do
      page.must_have_field "image_name"
    end

    it "has form field description" do
      page.must_have_field "image_description"
    end

    it "has form field image" do
      page.must_have_field "image_image"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :edit" do
    before do
      @image = Fabricate(:image, project: @project, name: "bf_image_test", description: "image test 1")
      visit edit_admin_project_image_path(@project, @image)
    end

    it "shows the correct url" do
      page.current_url.must_include('/edit')
    end

    it "has form field with submitted name" do
      page.must_have_field "image_name", with: "bf_image_test"
    end

    it "has form field with submitted description" do
      page.must_have_field "image_description", with: "image test 1"
    end

    it "has form field with submitted image" do
      page.must_have_xpath("//img[contains(@src,\"Desktop.jpg\")]")
    end

     it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :show" do
    before do
      @image = Fabricate(:image, project: @project, name: "bf_image_test", description: "image test 1")
    end

    it "shows correct url and project image info :html" do
      visit admin_project_image_path(@project, @image)
      path_id = @image.id.to_s
      page.current_url.must_include('/images/' + path_id)
      page.must_have_content 'bf_image_test'
      page.must_have_content "image test 1"
      page.must_have_xpath("//img[contains(@src,\"Desktop.jpg\")]")
    end

    it "shows correct url and project image info :json" do
      visit admin_project_image_path(@project, @image, format: :json)
      path_id = @image.id.to_s
      page.current_url.must_include('/images/' + path_id + '.json')
      page.must_have_content '"name":"bf_image_test"'
      page.must_have_content '"description":"image test 1"'
      page.must_have_content 'Desktop.jpg'
    end
  end

  describe "on POST to :create" do
    it "sucessfully create a new image :html" do
      visit new_admin_project_image_path(@project)
      page.fill_in "image_name", with: "bf_image_test"
      page.fill_in "image_description", with: "image test 1"
      page.attach_file("image_image", File.join(::Rails.root, ('test/support/QR.png')))
      page.click_on "Save"
      page.must_have_content "Image was successfully created."
      page.must_have_content 'bf_image_test'
      page.must_have_content "image test 1"
      page.must_have_selector('img', visible: true)
    end

    it "sucessfully create a new image :json" do
      skip
    end

    it "fails to create a new image" do
      visit new_admin_project_image_path(@project)
      page.fill_in "image_name", with: "bf_image_test"
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to create a new image :json" do
      skip
    end
  end

  describe "on PUT to :update" do
    before do
      @image = Fabricate(:image, project: @project, name: "bf_image_test", description: "image test 1")
      visit edit_admin_project_image_path(@project, @image)
    end

    it "sucessfully update an image :html" do
      page.fill_in "Name", with: "new_name"
      page.fill_in "Description", with: "new_description"
      page.attach_file("image_image", File.join(::Rails.root, ('test/support/QR.png')))
      page.click_on "Save"
      page.must_have_content "Image was successfully updated."
      page.must_have_content "new_name"
      page.must_have_content "new_description"
      page.must_have_selector('img', visible: true)
    end

    it "sucessfully update an image :json" do
      skip
    end

    it "fails to update an image" do
      skip
      # page.click_on "Save"
      # page.must_have_content "prohibited this project from being saved"
    end

    it "fails to update an image :json" do
      skip
    end
  end

  describe "on POST to :delete" do
    before do
      @image = Fabricate(:image, project: @project, name: "bf_image_test")
    end

    it "sucessfully deletes an image :html" do
      visit admin_project_images_path(@project)
      page.must_have_content "bf_image_test"
      page.click_on "Delete"
      visit admin_project_images_path(@project)
      page.wont_have_content "bf_image_test"
    end

    it "sucessfully deletes an image :json" do
      visit admin_project_images_path(@project)
      page.must_have_content "bf_image_test"
      page.driver.delete admin_project_image_path(@project, @image, format: :json)
      visit admin_project_images_path(@project)
      page.wont_have_content "bf_image_test"
    end
  end

  describe "on GET image to :approve" do
    before do
      @image = Fabricate(:image, project: @project)
    end

    it "sucessfully approves an image :html" do
      visit admin_project_image_path(@project, @image)
      page.must_have_content "pending"
      page.driver.get approve_admin_project_image_path(@project, @image)
      visit admin_project_image_path(@project, @image)
      page.must_have_content "approved"
    end

    it "sucessfully approves an image :json" do
      visit approve_admin_project_image_path(@project, @image, format: :json)
      page.current_url.must_include('/approve.json')
      page.must_have_content '"status":"success"'
    end
  end

  describe "on GET image to :deny" do
    before do
      @image = Fabricate(:image, project: @project)
    end

    it "successfully denies an image :html" do
      visit admin_project_image_path(@project, @image)
      page.must_have_content "pending"
      page.driver.get deny_admin_project_image_path(@project, @image)
      visit admin_project_image_path(@project, @image)
      page.must_have_content "denied"
    end

    it "successfully denies an image :json" do
      visit deny_admin_project_image_path(@project, @image, format: :json)
      page.current_url.must_include('/deny.json')
      page.must_have_content '"status":"success"'
    end
  end
end
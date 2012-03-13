require "minitest_helper"

describe "Admin Facebook Albums Integration Test" do
  before do
    sign_in Fabricate(:user)
    @project = Fabricate(:project, name: "bf_project_test")
  end

  describe "on GET to :index" do
    before do
      @facebook_album = Fabricate(:facebook_album, project: @project, name: "bf_facebook_album_test")
    end

    it "shows correct url and facebook_album name :html" do
      visit admin_project_facebook_albums_path(@project)
      page.current_url.must_include('/bf_project_test/facebook_albums')
      page.must_have_content "bf_facebook_album_test"
    end

    it "shows correct url and facebook_album name :json" do
      visit admin_project_facebook_albums_path(@project, format: :json)
      page.current_url.must_include('/bf_project_test/facebook_albums.json')
      page.must_have_content "bf_facebook_album_test"
    end
  end

  describe "on GET to :new" do
    before do
      visit new_admin_project_facebook_album_path(@project)
    end

    it "shows the correct url" do
      page.current_url.must_include('/facebook_albums/new')
    end

    it "has form field name" do
      page.must_have_field "facebook_album_name"
    end

    it "has form field url" do
      page.must_have_field "facebook_album_set_id"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :edit" do
    before do
      @facebook_album = Fabricate(:facebook_album, project: @project, name: "bf_facebook_album_test", set_id: 1357924680)
      visit edit_admin_project_facebook_album_path(@project, @facebook_album)
    end

    it "shows the correct url" do
      page.current_url.must_include('/edit')
    end

    it "has form field with submitted name" do
      page.must_have_field "facebook_album_name", with: "bf_facebook_album_test"
    end

    it "has form field with submitted set id" do
      page.must_have_field "facebook_album_set_id", with: "1357924680"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :show" do
    before do
      @facebook_album = Fabricate(:facebook_album, project: @project, name: "bf_facebook_album_test", set_id: 1357924680)
    end

    it "shows correct facebook_album info :html" do
      visit admin_project_facebook_album_path(@project, @facebook_album)
      path_id = @facebook_album.id.to_s
      page.current_url.must_include('/facebook_albums/' + path_id)
      page.must_have_content 'bf_facebook_album_test'
      page.must_have_content "1357924680"
    end

    it "shows correct facebook_album info :json" do
      visit admin_project_facebook_album_path(@project, @facebook_album, format: :json)
      path_id = @facebook_album.id.to_s
      page.current_url.must_include('/facebook_albums/' + path_id + '.json')
      page.must_have_content '"name":"bf_facebook_album_test"'
      page.must_have_content '"set_id":1357924680'
    end
  end

  describe "on POST to :create" do
    it "sucessfully create a new facebook_album :html" do
      visit new_admin_project_facebook_album_path(@project)
      page.fill_in "facebook_album_name", with: "bf_facebook_album_test"
      page.fill_in "facebook_album_set_id", with: "1357924680"
      page.click_on "Save"
      page.must_have_content "Facebook album was successfully created."
      page.must_have_content 'bf_facebook_album_test'
      page.must_have_content "1357924680"
    end

    it "sucessfully create a new facebook_album :json" do
      skip
    end

    it "fails to create a new facebook_album" do
      visit new_admin_project_facebook_album_path(@project)
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to create a new facebook_album :json" do
      skip
    end
  end

  describe "on PUT to :update" do
    before do
      @facebook_album = Fabricate(:facebook_album, project: @project, name: "bf_facebook_album_test", set_id: 1357924680)
      visit edit_admin_project_facebook_album_path(@project, @facebook_album)
    end

    it "sucessfully update a facebook_album :html" do
      page.fill_in "facebook_album_name", with: "new_name"
      page.fill_in "facebook_album_set_id", with: "987654321"
      page.click_on "Save"
      page.must_have_content "Facebook album was successfully updated."
      page.must_have_content "987654321"
    end

    it "sucessfully update a facebook_album :json" do
      skip
    end

    it "fails to update a facebook_album" do
      page.fill_in "facebook_album_name", with: ""
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to update a facebook_album :json" do
      skip
    end
  end

  describe "on POST to :delete" do
    before do
      @facebook_album = Fabricate(:facebook_album, project: @project, name: "bf_facebook_album_test")
    end

    it "sucessfully deletes a facebook_album :html" do
      visit admin_project_facebook_albums_path(@project)
      page.must_have_content "bf_facebook_album_test"
      page.click_on "Delete"
      visit admin_project_facebook_albums_path(@project)
      page.wont_have_content "bf_facebook_album_test"
    end

    it "sucessfully deletes a facebook_album :json" do
      visit admin_project_facebook_albums_path(@project)
      page.must_have_content "bf_facebook_album_test"
      page.driver.delete admin_project_facebook_album_path(@project, @facebook_album, format: :json)
      visit admin_project_facebook_albums_path(@project)
      page.wont_have_content "bf_facebook_album_test"
    end
  end
end
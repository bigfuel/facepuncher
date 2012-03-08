require "minitest_helper"

describe "Admin videos Integration Test" do
  before do
    sign_in Fabricate(:user)
    @project = Fabricate(:project, name: "bf_project_test")
  end

  describe "on GET to :index" do
    before do
      @video = Fabricate(:video, project: @project, name: "bf_video_test")
    end

    it "shows correct url and video name :html" do
      visit admin_project_videos_path(@project)
      page.current_url.must_include('/bf_project_test/videos')
      page.must_have_content "bf_video_test"
    end

    it "shows correct url and video name :json" do
      visit admin_project_videos_path(@project, format: :json)
      page.current_url.must_include('/bf_project_test/videos.json')
      page.must_have_content "bf_video_test"
    end
  end

  describe "on GET to :new" do
    before do
      visit new_admin_project_video_path(@project)
    end

    it "shows the correct url" do
      page.current_url.must_include('/videos/new')
    end

    it "has form field name" do
      page.must_have_field "video_name"
    end

    it "has form field youtube id" do
      page.must_have_field "video_youtube_id"
    end

    it "has form field description" do
      page.must_have_field "video_description"
    end

    it "has form field screencap" do
      page.must_have_field "video_screencap"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :edit" do
    before do
      @video = Fabricate(:video, project: @project, name: "bf_video_test", youtube_id: "1v2i3d4e5o", description: "video test 1")
      visit edit_admin_project_video_path(@project, @video)
    end

    it "shows the correct url" do
      page.current_url.must_include('/edit')
    end

    it "has form field with submitted  name" do
      page.must_have_field "video_name", with: "bf_video_test"
    end

    it "has form field with submitted youtube id" do
      page.must_have_field "video_youtube_id", with: "1v2i3d4e5o"
    end

    it "has form field with submitted description" do
      page.must_have_field "video_description", with: "video test 1"
    end

    it "has form field with submitted screencap" do
      page.must_have_xpath("//img[contains(@src,\"Desktop.jpg\")]")
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :show" do
    before do
      @video = Fabricate(:video, project: @project, name: "bf_video_test", youtube_id: "1v2i3d4e5o", description: "video test 1")
    end

    it "shows correct url and project video info :html" do
      visit admin_project_video_path(@project, @video)
      path_id = @video.id.to_s
      page.current_url.must_include('/videos/' + path_id)
      page.must_have_content 'bf_video_test'
      page.must_have_content "1v2i3d4e5o"
      page.must_have_content "video test 1"
      page.must_have_xpath("//img[contains(@src,\"Desktop.jpg\")]")
    end

    it "shows correct url and project video info :json" do
      visit admin_project_video_path(@project, @video, format: :json)
      path_id = @video.id.to_s
      page.current_url.must_include('/videos/' + path_id + '.json')
      page.must_have_content '"name":"bf_video_test"'
      page.must_have_content '"youtube_id":"1v2i3d4e5o"'
      page.must_have_content '"description":"video test 1"'
      page.must_have_content 'Desktop.jpg'
    end
  end

  describe "on POST to :create" do
    it "sucessfully create a new video :html" do
      visit new_admin_project_video_path(@project)
      page.fill_in "video_name", with: "bf_video_test"
      page.fill_in "video_youtube_id", with: "1v2i3d4e5o"
      page.fill_in "video_description", with: "video test 1"
      page.attach_file("video_screencap", File.join(::Rails.root, ('test/support/Desktop.jpg')))
      page.click_on "Save"
      page.must_have_content "Video was successfully created."
      page.must_have_content 'bf_video_test'
      page.must_have_content "1v2i3d4e5o"
      page.must_have_content "video test 1"
      page.must_have_xpath("//img[contains(@src,\"Desktop.jpg\")]")
    end

    it "sucessfully create a new video :json" do
      skip
    end

    it "fails to create a new video" do
      visit new_admin_project_video_path(@project)
      page.fill_in "video_name", with: "bf_video_test"
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to create a new video :json" do
      skip
    end
  end

  describe "on PUT to :update" do
    before do
      @video = Fabricate(:video, project: @project, name: "bf_video_test", youtube_id: "1v2i3d4e5o", description: "video test 1")
      visit edit_admin_project_video_path(@project, @video)
    end

    it "sucessfully update a video :html" do
      page.fill_in "Name", with: "new_name"
      page.fill_in "YouTube Video ID", with: "new12351236"
      page.fill_in "Description", with: "new_description"
      page.attach_file("video_screencap", File.join(::Rails.root, ('test/support/QR.png')))
      page.click_on "Save"
      page.must_have_content "Video was successfully updated."
      page.must_have_content "new_name"
      page.must_have_content "new12351236"
      page.must_have_content "new_description"
      page.must_have_xpath("//img[contains(@src,\"QR.png\")]")
    end

    it "sucessfully update a video :json" do
      skip
    end

    it "fails to update a video" do
      page.fill_in "YouTube Video ID", with: ""
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to update a video :json" do
      skip
    end
  end

  describe "on POST to :delete" do
    before do
      @video = Fabricate(:video, project: @project, name: "bf_video_test")
    end

    it "sucessfully deletes a video :html" do
      visit admin_project_videos_path(@project)
      page.must_have_content "bf_video_test"
      page.click_on "Delete"
      visit admin_project_videos_path(@project)
      page.wont_have_content "bf_video_test"
    end

    it "sucessfully deletes a video :json" do
      visit admin_project_videos_path(@project)
      page.must_have_content "bf_video_test"
      page.driver.delete admin_project_video_path(@project, @video, format: :json)
      visit admin_project_videos_path(@project)
      page.wont_have_content "bf_video_test"
    end
  end

  describe "on GET video to :approve" do
    before do
      @video = Fabricate(:video, project: @project)
    end

    it "sucessfully activates a project :html" do
      visit admin_project_video_path(@project, @video)
      page.must_have_content "pending"
      page.driver.get approve_admin_project_video_path(@project, @video)
      visit admin_project_video_path(@project, @video)
      page.must_have_content "approved"
    end

    it "sucessfully activates a project :json" do
      visit approve_admin_project_video_path(@project, @video, format: :json)
      page.current_url.must_include('/approve.json')
      page.must_have_content '"status":"success"'
    end
  end

  describe "on GET video to :deny" do
    before do
      @video = Fabricate(:video, project: @project)
    end

    it "successfully deactivates a project :html" do
      visit admin_project_video_path(@project, @video)
      page.must_have_content "pending"
      page.driver.get deny_admin_project_video_path(@project, @video)
      visit admin_project_video_path(@project, @video)
      page.must_have_content "denied"
    end

    it "successfully deactivates a project :json" do
      visit deny_admin_project_video_path(@project, @video, format: :json)
      page.current_url.must_include('/deny.json')
      page.must_have_content '"status":"success"'
    end
  end
end
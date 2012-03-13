require "minitest_helper"

describe "Admin Feeds Integration Test" do
  before do
    sign_in Fabricate(:user)
    @project = Fabricate(:project, name: "bf_project_test")
  end

  describe "on GET to :index" do
    before do
      @feed = Fabricate(:feed, project: @project, name: "bf_feed_test")
    end

    it "shows correct url and feed name :html" do
      visit admin_project_feeds_path(@project)
      page.current_url.must_include('/bf_project_test/feeds')
      page.must_have_content "bf_feed_test"
    end

    it "shows correct url and feed name :json" do
      visit admin_project_feeds_path(@project, format: :json)
      page.current_url.must_include('/bf_project_test/feeds.json')
      page.must_have_content "bf_feed_test"
    end
  end

  describe "on GET to :new" do
    before do
      visit new_admin_project_feed_path(@project)
    end

    it "shows the correct url" do
      page.current_url.must_include('/feeds/new')
    end

    it "has form field name" do
      page.must_have_field "feed_name"
    end

    it "has form field url" do
      page.must_have_field "feed_url"
    end

    it "has form field limit" do
      page.must_have_field "feed_limit"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :edit" do
    before do
      @feed = Fabricate(:feed, project: @project, name: "bf_feed_test", url: "http://feed.test.com")
      visit edit_admin_project_feed_path(@project, @feed)
    end

    it "shows the correct url" do
      page.current_url.must_include('/edit')
    end

    it "has form field with submitted name" do
      page.must_have_field "feed_name", with: "bf_feed_test"
    end

    it "has form field with submitted url" do
      page.must_have_field "feed_url", with: "http://feed.test.com"
    end

    it "has form field with default limit" do
      page.must_have_field "feed_limit", with: "10"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :show" do
    before do
      @feed = Fabricate(:feed, project: @project, name: "bf_feed_test", url: "http://feed.test.com", limit: 17)
    end

    it "shows correct feed info :html" do
      visit admin_project_feed_path(@project, @feed)
      path_id = @feed.id.to_s
      page.current_url.must_include('/feeds/' + path_id)
      page.must_have_content 'bf_feed_test'
      page.must_have_content "http://feed.test.com"
      page.must_have_content "17"
    end

    it "shows correct feed info :json" do
      visit admin_project_feed_path(@project, @feed, format: :json)
      path_id = @feed.id.to_s
      page.current_url.must_include('/feeds/' + path_id + '.json')
      page.must_have_content '"name":"bf_feed_test"'
      page.must_have_content '"url":"http://feed.test.com"'
      page.must_have_content '"limit":17'
    end
  end

  describe "on POST to :create" do
    it "sucessfully create a new feed :html" do
      visit new_admin_project_feed_path(@project)
      page.fill_in "feed_name", with: "bf_feed_test"
      page.fill_in "feed_url", with: "http://feed.test.com"
      page.fill_in "feed_limit", with: "17"
      page.click_on "Save"
      page.must_have_content "Feed was successfully created."
      page.must_have_content 'bf_feed_test'
      page.must_have_content "http://feed.test.com"
      page.must_have_content "17"
    end

    it "sucessfully create a new feed :json" do
      skip
    end

    it "fails to create a new feed" do
      visit new_admin_project_feed_path(@project)
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to create a new feed :json" do
      skip
    end
  end

  describe "on PUT to :update" do
    before do
      @feed = Fabricate(:feed, project: @project, name: "bf_feed_test", url: "http://feed.test.com")
      visit edit_admin_project_feed_path(@project, @feed)
    end

    it "sucessfully update a feed :html" do
      page.fill_in "feed_name", with: "new_name"
      page.fill_in "feed_url", with: "http://test.com"
      page.fill_in "feed_limit", with: "25"
      page.click_on "Save"
      page.must_have_content "Feed was successfully updated."
      page.must_have_content "new_name"
      page.must_have_content "http://test.com"
      page.must_have_content "25"
    end

    it "sucessfully update a feed :json" do
      skip
    end

    it "fails to update a feed" do
      page.fill_in "feed_name", with: ""
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to update a feed :json" do
      skip
    end
  end

  describe "on POST to :delete" do
    before do
      @feed = Fabricate(:feed, project: @project, name: "bf_feed_test")
    end

    it "sucessfully deletes a feed :html" do
      visit admin_project_feeds_path(@project)
      page.must_have_content "bf_feed_test"
      page.click_on "Delete"
      visit admin_project_feeds_path(@project)
      page.wont_have_content "bf_feed_test"
    end

    it "sucessfully deletes a feed :json" do
      visit admin_project_feeds_path(@project)
      page.must_have_content "bf_feed_test"
      page.driver.delete admin_project_feed_path(@project, @feed, format: :json)
      visit admin_project_feeds_path(@project)
      page.wont_have_content "bf_feed_test"
    end
  end
end
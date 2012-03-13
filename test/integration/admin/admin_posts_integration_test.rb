require "minitest_helper"

describe "Admin Posts Integration Test" do
  before do
    sign_in Fabricate(:user)
    @project = Fabricate(:project, name: "bf_project_test")
  end

  describe "on GET to :index" do
    before do
      @post = Fabricate(:post, project: @project, title: "bf_post_test")
    end

    it "shows correct url and post name :html" do
      visit admin_project_posts_path(@project)
      page.current_url.must_include('/bf_project_test/posts')
      page.must_have_content "bf_post_test"
    end

    it "shows correct url and post name :json" do
      visit admin_project_posts_path(@project, format: :json)
      page.current_url.must_include('/bf_project_test/posts.json')
      page.must_have_content "bf_post_test"
    end
  end

  describe "on GET to :new" do
    before do
      visit new_admin_project_post_path(@project)
    end

    it "shows the correct url" do
      page.current_url.must_include('/posts/new')
    end

    it "has form field title" do
      page.must_have_field "post_title"
    end

    it "has form field content" do
      page.must_have_field "post_content"
    end

    it "has form field url" do
      page.must_have_field "post_url"
    end

    it "has form field tags" do
      page.must_have_field "post_tags"
    end

    it "has form field image" do
      page.must_have_field "post_image"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :edit" do
    before do
      @post = Fabricate(:post, project: @project, title: "bf_post_test", content: "lorem ipsum post test", url: "http://post.test.com", tags: "post, test, tags, lorem, ipsum")
      visit edit_admin_project_post_path(@project, @post)
    end

    it "shows the correct url" do
      page.current_url.must_include('/edit')
    end

    it "has form field with submitted title" do
      page.must_have_field "post_title", with: "bf_post_test"
    end

    it "has form field with submitted content" do
      page.must_have_field "post_content", with: "lorem ipsum post test"
    end

    it "has form field with submitted url" do
      page.must_have_field "post_url", with: "http://post.test.com"
    end

    it "has form field with submitted tags" do
      page.must_have_field "post_tags", with: "post, test, tags, lorem, ipsum"
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
      @post = Fabricate(:post, project: @project, title: "bf_post_test", content: "lorem ipsum post test", url: "http://post.test.com", tags: "post, test, tags, lorem, ipsum")
    end

    it "shows correct url and project post info :html" do
      visit admin_project_post_path(@project, @post)
      path_id = @post.id.to_s
      page.current_url.must_include('/posts/' + path_id)
      page.must_have_content 'bf_post_test'
      page.must_have_content "lorem ipsum post test"
      page.must_have_content "http://post.test.com"
      page.must_have_content "post, test, tags, lorem, ipsum"
      page.must_have_xpath("//img[contains(@src,\"Desktop.jpg\")]")
    end

    it "shows correct url and project post info :json" do
      visit admin_project_post_path(@project, @post, format: :json)
      path_id = @post.id.to_s
      page.current_url.must_include('/posts/' + path_id + '.json')
      page.must_have_content '"title":"bf_post_test"'
      page.must_have_content '"content":"lorem ipsum post test"'
      page.must_have_content '"url":"http://post.test.com"'
      page.must_have_content '"tags_array":["post,","test,","tags,","lorem,","ipsum"]'
      page.must_have_content 'Desktop.jpg'
    end
  end

  describe "on POST to :create" do
    it "sucessfully create a new post :html" do
      visit new_admin_project_post_path(@project)
      page.fill_in "post_title", with: "bf_post_test"
      page.fill_in "post_content", with: "lorem ipsum post test"
      page.fill_in "post_url", with: "http://post.test.com"
      page.fill_in "post_tags", with: "post, test, tags, lorem, ipsum"
      page.attach_file("post_image", File.join(::Rails.root, ('test/support/Desktop.jpg')))
      page.click_on "Save"
      page.must_have_content "Post was successfully created."
      page.must_have_content 'bf_post_test'
      page.must_have_content "lorem ipsum post test"
      page.must_have_content "http://post.test.com"
      page.must_have_content "post, test, tags, lorem, ipsum"
      page.must_have_xpath("//img[contains(@src,\"Desktop.jpg\")]")
    end

    it "sucessfully create a new post :json" do
      skip
    end

    it "fails to create a new post" do
      visit new_admin_project_post_path(@project)
      page.fill_in "post_title", with: "bf_post_test"
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to create a new post :json" do
      skip
    end
  end

  describe "on PUT to :update" do
    before do
      @post = Fabricate(:post, project: @project, title: "bf_post_test", content: "lorem ipsum post test", url: "http://post.test.com", tags: "post, test, tags, lorem, ipsum")
      visit edit_admin_project_post_path(@project, @post)
    end

    it "sucessfully update a post :html" do
      page.fill_in "post_title", with: "new_post_test"
      page.fill_in "post_content", with: "new ipsum test post"
      page.fill_in "post_url", with: "http://test.com"
      page.fill_in "post_tags", with: "new, test, lorem"
      page.attach_file("post_image", File.join(::Rails.root, ('test/support/QR.png')))
      page.click_on "Save"
      page.must_have_content "Post was successfully updated."
      page.must_have_content 'new_post_test'
      page.must_have_content "new ipsum test post"
      page.must_have_content "http://test.com"
      page.must_have_content "new, test, lorem"
      page.must_have_xpath("//img[contains(@src,\"QR.png\")]")
    end

    it "sucessfully update a post :json" do
      skip
    end

    it "fails to update a post" do
      page.fill_in "post_title", with: ""
      page.fill_in "post_content", with: ""
      page.fill_in "post_url", with: ""
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to update a post :json" do
      skip
    end
  end

  describe "on POST to :delete" do
    before do
      @post = Fabricate(:post, project: @project, title: "bf_post_test")
    end

    it "sucessfully deletes a post :html" do
      visit admin_project_posts_path(@project)
      page.must_have_content "bf_post_test"
      page.click_on "Delete"
      visit admin_project_posts_path(@project)
      page.wont_have_content "bf_post_test"
    end

    it "sucessfully deletes a post :json" do
      visit admin_project_posts_path(@project)
      page.must_have_content "bf_post_test"
      page.driver.delete admin_project_post_path(@project, @post, format: :json)
      visit admin_project_posts_path(@project)
      page.wont_have_content "bf_post_test"
    end
  end

  describe "on GET post to :approve" do
    before do
      @post = Fabricate(:post, project: @project)
    end

    it "sucessfully approves a project :html" do
      visit admin_project_post_path(@project, @post)
      page.must_have_content "pending"
      page.driver.get approve_admin_project_post_path(@project, @post)
      visit admin_project_post_path(@project, @post)
      page.must_have_content "approved"
    end

    it "sucessfully approves a project :json" do
      visit approve_admin_project_post_path(@project, @post, format: :json)
      page.current_url.must_include('/approve.json')
      page.must_have_content '"status":"success"'
    end
  end

  describe "on GET post to :deny" do
    before do
      @post = Fabricate(:post, project: @project)
    end

    it "successfully denies a project :html" do
      visit admin_project_post_path(@project, @post)
      page.must_have_content "pending"
      page.driver.get deny_admin_project_post_path(@project, @post)
      visit admin_project_post_path(@project, @post)
      page.must_have_content "denied"
    end

    it "successfully denies a project :json" do
      visit deny_admin_project_post_path(@project, @post, format: :json)
      page.current_url.must_include('/deny.json')
      page.must_have_content '"status":"success"'
    end
  end

  describe "on PUT :up to post" do
    before do
      @post = Fabricate(:post, project: @project)
    end

    it "successfully moves the post up" do
      skip
    end
  end


  describe "on PUT :down to post" do
    before do
      @post = Fabricate(:post, project: @project)
    end

    it "successfully moves the post down" do
      skip
    end
  end

end
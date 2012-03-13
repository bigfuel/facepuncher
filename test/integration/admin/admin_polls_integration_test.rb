require "minitest_helper"

describe "Admin Polls Integration Test" do
  before do
    sign_in Fabricate(:user)
    @project = Fabricate(:project, name: "bf_project_test")
  end

  describe "on GET to :index" do
    before do
      @poll = Fabricate(:poll, project: @project, question: "bf_poll_test")
    end

    it "shows correct url and poll name :html" do
      visit admin_project_polls_path(@project)
      page.current_url.must_include('/bf_project_test/polls')
      page.must_have_content "bf_poll_test"
    end

    it "shows correct url and poll name :json" do
      visit admin_project_polls_path(@project, format: :json)
      page.current_url.must_include('/bf_project_test/polls.json')
      page.must_have_content "bf_poll_test"
    end
  end

  describe "on GET to :new" do
    before do
      visit new_admin_project_poll_path(@project)
    end

    it "shows the correct url" do
      page.current_url.must_include('/polls/new')
    end

    it "has form field question" do
      page.must_have_field "poll_question"
    end

    it "has form field 2 choices" do
      page.must_have_field "poll_choices_attributes_0_content"
      page.must_have_field "poll_choices_attributes_0_image"
      page.must_have_field "poll_choices_attributes_1_content"
      page.must_have_field "poll_choices_attributes_1_image"
    end

    it "has form field start date" do
      page.must_have_field "poll_start_date"
    end

    it "has form field end date" do
      page.must_have_field "poll_end_date"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :edit" do
    before do
      @poll = Fabricate(:poll, project: @project, question: "bf_poll_test", start_date: "2003-11-11 04:00:00 AM", end_date: "2005-11-11 06:00:00 AM", choices:[{content: "first_choice"}, {content: "second_choice"}])
      visit edit_admin_project_poll_path(@project, @poll)
    end

    it "shows the correct url" do
      page.current_url.must_include('/edit')
    end

    it "has form field with submitted question" do
      page.must_have_field "poll_question", with: "bf_poll_test"
    end

    it "has form field with 2 submitted choices" do
      page.must_have_field "poll_choices_attributes_0_content", with: "first_choice"
      page.must_have_field "poll_choices_attributes_1_content", with: "second_choice"
    end

    it "has form field with submitted start date" do
      page.must_have_field "poll_start_date", with: "2003-11-11 04:00:00 AM"
    end

    it "has form field with submitted end date" do
      page.must_have_field "poll_end_date", with: "2005-11-11 06:00:00 AM"
    end

    it "has save button" do
      page.must_have_button "Save"
    end
  end

  describe "on GET to :show" do
    before do
      @poll = Fabricate(:poll, project: @project, question: "bf_poll_test", start_date: "2003-11-11 04:00:00 AM", end_date: "2005-11-11 06:00:00 AM", choices:[{content: "first_choice"}, {content: "second_choice"}])
    end

    it "shows correct url and project poll info :html" do
      visit admin_project_poll_path(@project, @poll)
      path_id = @poll.id.to_s
      page.current_url.must_include('/polls/' + path_id)
      page.must_have_content 'bf_poll_test'
      page.must_have_content "2003-11-11 04:00:00 AM"
      page.must_have_content "2005-11-11 06:00:00 AM"
      page.must_have_content "first_choice"
      page.must_have_content "second_choice"
      page.must_have_button "Vote"
    end

    it "shows correct url and project poll info :json" do
      visit admin_project_poll_path(@project, @poll, format: :json)
      path_id = @poll.id.to_s
      page.current_url.must_include('/polls/' + path_id + '.json')
      page.must_have_content '"question":"bf_poll_test"'
      page.must_have_content '"start_date":"2003-11-11T04:00:00-05:00"'
      page.must_have_content '"end_date":"2005-11-11T06:00:00-05:00"'
      page.must_have_content '"content":"first_choice"'
      page.must_have_content '"content":"second_choice"'
    end
  end

  describe "on POST to :create" do
    it "sucessfully create a new poll :html" do
      visit new_admin_project_poll_path(@project)
      page.fill_in "poll_question", with: "bf_poll_test"
      page.fill_in "poll_choices_attributes_0_content", with: "first_choice"
      page.attach_file("poll_choices_attributes_0_image", File.join(::Rails.root, ('test/support/Desktop.jpg')))
      page.fill_in "poll_choices_attributes_1_content", with: "second_choice"
      page.attach_file("poll_choices_attributes_1_image", File.join(::Rails.root, ('test/support/QR.png')))
      page.fill_in "poll_start_date", with: "2003-11-11 04:00:00 AM"
      page.fill_in "poll_end_date", with: "2005-11-11 06:00:00 AM"
      page.click_on "Save"
      page.must_have_content "Poll was successfully created."
      page.must_have_content 'bf_poll_test'
      page.must_have_content "2003-11-11 04:00:00 AM"
      page.must_have_content "2005-11-11 06:00:00 AM"
      page.must_have_content "first_choice"
      page.must_have_xpath("//img[contains(@src,\"Desktop.jpg\")]")
      page.must_have_content "second_choice"
      page.must_have_xpath("//img[contains(@src,\"QR.png\")]")
    end

    it "sucessfully create a new poll :json" do
      skip
    end

    it "fails to create a new poll" do
      visit new_admin_project_poll_path(@project)
      page.fill_in "poll_start_date", with: "2003-11-11 04:00:00 AM"
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to create a new poll :json" do
      skip
    end
  end

  describe "on PUT to :update" do
    before do
      @poll = Fabricate(:poll, project: @project, question: "bf_poll_test", start_date: "2003-11-11 04:00:00 AM", end_date: "2005-11-11 06:00:00 AM", choices:[{content: "first_choice"}, {content: "second_choice"}])
      visit edit_admin_project_poll_path(@project, @poll)
    end

    it "sucessfully update a poll :html" do
      page.fill_in "poll_question", with: "update_poll_test"
      page.fill_in "poll_choices_attributes_0_content", with: "new_choice_1"
      page.attach_file("poll_choices_attributes_0_image", File.join(::Rails.root, ('test/support/food1.jpg')))
      page.fill_in "poll_choices_attributes_1_content", with: "new_choice_2"
      page.attach_file("poll_choices_attributes_1_image", File.join(::Rails.root, ('test/support/food2.jpg')))
      page.fill_in "poll_start_date", with: "2003-01-01 05:00:00 AM"
      page.fill_in "poll_end_date", with: "2005-01-01 07:00:00 AM"
      page.click_on "Save"
      page.must_have_content "update_poll_test"
      page.must_have_content "2003-01-01 05:00:00 AM"
      page.must_have_content "2005-01-01 07:00:00 AM"
      page.must_have_content "new_choice_1"
      page.must_have_xpath("//img[contains(@src,\"food1.jpg\")]")
      page.must_have_content "new_choice_2"
      page.must_have_xpath("//img[contains(@src,\"food2.jpg\")]")
    end

    it "sucessfully update a poll :json" do
      skip
    end

    it "fails to update a poll" do
      page.fill_in "poll_question", with: ""
      page.click_on "Save"
      page.must_have_content "prohibited this project from being saved"
    end

    it "fails to update a poll :json" do
      skip
    end
  end

  describe "on POST to :delete" do
    before do
      @poll = Fabricate(:poll, project: @project, question: "bf_poll_test")
    end

    it "sucessfully deletes a poll :html" do
      visit admin_project_polls_path(@project)
      page.must_have_content "bf_poll_test"
      page.click_on "Delete"
      visit admin_project_polls_path(@project)
      page.wont_have_content "bf_poll_test"
    end

    it "sucessfully deletes a poll :json" do
      visit admin_project_polls_path(@project)
      page.must_have_content "bf_poll_test"
      page.driver.delete admin_project_poll_path(@project, @poll, format: :json)
      visit admin_project_polls_path(@project)
      page.wont_have_content "bf_poll_test"
    end
  end

  describe "on GET poll to :activate" do
    before do
      @poll = Fabricate(:poll, project: @project)
    end

    it "sucessfully activates a project :html" do
      visit admin_project_poll_path(@project, @poll)
      page.must_have_content "inactive"
      page.driver.get activate_admin_project_poll_path(@project, @poll)
      visit admin_project_poll_path(@project, @poll)
      page.must_have_content "active"
    end

    it "sucessfully activates a project :json" do
      visit activate_admin_project_poll_path(@project, @poll, format: :json)
      page.current_url.must_include('/activate.json')
      page.must_have_content '"status":"success"'
    end
  end

  describe "on GET poll to :deactivate" do
    before do
      @poll = Fabricate(:poll, project: @project)
    end

    it "successfully deactivates a project :html" do
      visit admin_project_poll_path(@project, @poll)
      page.must_have_content "active"
      page.driver.get deactivate_admin_project_poll_path(@project, @poll)
      visit admin_project_poll_path(@project, @poll)
      page.must_have_content "inactive"
    end

    it "successfully deactivates a project :json" do
      visit deactivate_admin_project_poll_path(@project, @poll, format: :json)
      page.current_url.must_include('/deactivate.json')
      page.must_have_content '"status":"success"'
    end
  end

  describe "on PUT to :vote on a choice in poll" do
    before do
      @poll = Fabricate(:poll, project: @project)
    end

    it "successfully votes on a choice in poll" do
      skip "problem with vote in controller"
      # visit admin_project_poll_path(@project, @poll)
      # page.choose "choice[id]"
      # page.click_on "Vote"
    end
  end
end
require 'minitest_helper'

describe PollsController do
  before do
    @project = Fabricate(:project, name: 'bf_project_test')
    @project.activate
  end

  describe "persisted poll" do
    before do
      @poll = Fabricate(:poll, project: @project)
      @poll.activate
    end

    describe "show action" do
      it "render show template" do
        get :show, project_name: @project.name, id: @poll.id
        assert_template 'show'
      end
    end

    describe "vote action" do
      it "render edit template when poll is invalid" do
        put :vote, project_name: @project.name, id: @poll.id
        assert_redirected_to '/500.html'
      end

      it "redirect when poll is valid" do
        referrer = 'http://whatever'
        @request.env['HTTP_REFERER'] = referrer
        put :vote, project_name: @project.name, id: @poll.id, choice: { id: @poll.choices.first.id }
        assert_redirected_to referrer
      end
    end
  end
end
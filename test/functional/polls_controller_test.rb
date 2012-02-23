require 'test_helper'

class PollsControllerTest < ActionController::TestCase
  setup do
    @project = Fabricate(:project, name: 'bf_project_test')
    @project.activate
  end

  context "persisted poll" do
    setup do
      @poll = Fabricate(:poll, project: @project)
      @poll.activate
    end

    context "show action" do
      should "render show template" do
        get :show, project_name: @project.name, id: @poll.id
        assert_template 'show'
      end
    end

    context "vote action" do
      should "render edit template when poll is invalid" do
        put :vote, project_name: @project.name, id: @poll.id
        assert_redirected_to '/500.html'
      end

      should "redirect when poll is valid" do
        referrer = 'http://whatever'
        @request.env['HTTP_REFERER'] = referrer
        put :vote, project_name: @project.name, id: @poll.id, choice: { id: @poll.choices.first.id }
        assert_redirected_to referrer
      end
    end
  end
end
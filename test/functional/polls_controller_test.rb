require 'minitest_helper'

describe PollsController do
  before do
    @project = load_project
  end

  describe "on GET to :show" do
    before do
      Project.any_instance.stubs(polls: stub(active: stub(find: Fabricate.build(:poll))))
      get :show, project_name: @project.name, id: "1", format: :json
    end

    it "returns a poll object" do
      must_respond_with :success
      poll = assigns(:poll)
      poll.wont_be_nil
    end
  end

  describe "on GET to :vote" do
    before do
      @poll = Fabricate.build(:poll, project: @project)
    end

    it "with a valid poll should redirect to referrer" do
      Project.any_instance.stubs(polls: stub(active: stub(find: Fabricate.build(:poll))))
      referrer = 'http://example.com'
      @request.env['HTTP_REFERER'] = referrer
      put :vote, project_name: @project.name, id: "1", choice: { id: @poll.choices.first.id }
      must_redirect_to referrer
    end

    it "with an empty choice should render 500 template" do
      put :vote, project_name: @project.name, id: "1"
      must_redirect_to '/500.html'
    end
  end
end
require 'minitest_helper'

describe PollsController do
  before do
    @project = load_project
  end

  describe "on GET to :show" do
    before do
      Project.any_instance.stubs(polls: stub(active: stub(find: Fabricate.build(:poll, project: @project))))
      get :show, format: :json, project_id: @project, id: "1"
    end

    it "returns a poll object" do
      must_respond_with :success
      poll = assigns(:poll)
      poll.wont_be_nil
    end
  end

  describe "on GET to :vote" do
    before do
      Project.any_instance.stubs(polls: stub(active: stub(find: Fabricate.build(:poll, project: @project))))
    end

    it "with a valid poll" do
      Poll.any_instance.stubs(vote: true)
      put :vote, format: :json, project_id: @project, id: "1", choice: { id: "100" }
      must_respond_with :success
    end

    it "with a blank choice should return a validation error" do
      put :vote, format: :json, project_id: @project, id: "1", choice: { id: "" }
      must_respond_with :unprocessable_entity
    end

    it "with a nonexistant choice should return a validation error" do
      put :vote, format: :json, project_id: @project, id: "1", choice: { id: "400000000000000000000000" }
      must_respond_with :unprocessable_entity
    end
  end
end
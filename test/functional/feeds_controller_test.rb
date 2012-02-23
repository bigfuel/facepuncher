require 'test_helper'

class FeedsControllerTest < ActionController::TestCase
  setup do
    @project = Fabricate(:project, name: "bf_project_test")
    @project.activate
  end

  context "on GET to :index" do
    should "return a list of feed entries in json format" do
      flunk
    end
  end
end
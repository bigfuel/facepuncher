require 'minitest_helper'

describe FeedsController do
  before do
    @project = Fabricate(:project, name: "bf_project_test")
    @project.activate
  end

  describe "on GET to :index" do
    it "return a list of feed entries in json format" do
      skip
    end
  end
end
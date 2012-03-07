require 'minitest_helper'

describe Api::FeedsController do
  before do
    @project = load_project
  end

  describe "on GET to :show" do
    it "with a feed name, returns a list of feed entries in json format" do
      skip
    end
  end
end
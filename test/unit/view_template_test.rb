require 'minitest_helper'

describe ViewTemplate do
  describe "A view template" do
    before do
      @view_template = Fabricate(:view_template)
    end

    it "should be valid" do
      @view_template.must_be :valid?
    end
  end
end

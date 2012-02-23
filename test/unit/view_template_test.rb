require 'test_helper'

class ViewTemplateTest < ActiveSupport::TestCase
  context ViewTemplate do
    setup do
      @vt = Fabricate(:view_template)
    end

    should "be valid" do
      assert @vt.valid?
    end
  end
end

require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  should validate_presence_of(:branch)
  should validate_presence_of(:live_date)

  context Release do
    setup do
      @project = Fabricate(:release)
    end

    should "be valid" do
      assert @project.valid?
    end
  end
end
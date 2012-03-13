require 'minitest_helper'

describe Release do
  it "should have validations" do
    release = Fabricate.build(:release)
    release.must have_valid(:branch)
    release.wont have_valid(:branch).when(nil)

    release.must have_valid(:live_date)
    release.wont have_valid(:live_date).when(Time.now - 10.minutes)
  end

  describe "A release" do
    before do
      @release = Fabricate(:release)
    end

    it "should be valid" do
      @release.must_be :valid?
    end
  end
end
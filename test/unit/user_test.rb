require "minitest_helper"

describe User do
  it "should have validations" do
    user = Fabricate.build(:user)

    user.must have_valid(:email).when("test@example.com")
    user.wont have_valid(:email).when("")
  end

  describe "A user" do
    before do
      @user = Fabricate(:user)
    end

    it "must be valid" do
      @user.must_be :valid?
    end
  end
end
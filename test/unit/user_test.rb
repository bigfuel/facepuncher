require "test_helper"

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:email)

  context User do
    setup do
      @user = Fabricate(:user)
    end

    should "must be valid" do
      assert @user.valid?
    end
  end
end
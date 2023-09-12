require "test_helper"

class UserTest < ActiveSupport::TestCase
  # setup method (runs automatically before each test) to create an initially valid user object
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end
end

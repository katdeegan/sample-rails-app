require "test_helper"

class UserTest < ActiveSupport::TestCase
  # setup method (runs automatically before each test) to create an initially valid user object
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    # assert method - tests condition that should be true
    assert @user.valid?
  end

  # testing attribute presence
  test "name should be present" do
    @user.name = "     "
    # assert_not passes if object is nil or false
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  # testing maximum length of attributes
  test "name should not be too long" do
    # user name should be displayed on site, don't want it to be too long
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    # many DBs have max length of 255 characters
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    ##duplicate_user.email = @user.email.upcase # validate uniqueness regardless of case
    @user.save
    assert_not duplicate_user.valid?
  end

  # enforce minimum password complexity requirements
  test "password should be present (nonblank)" do
    # compact multiple assignment - assigns password + password_confirmation at the same time
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # if user opens app in a seperate browser
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

end

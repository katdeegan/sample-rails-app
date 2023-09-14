require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) # fixture creates valid user
  end
  test "login with invalid information" do
    # 1. visit login path
    get login_path

    # 2. verify new session form renders
    assert_template 'session/new'

    # 3. post sessions path with invalid
    post login_path, params: { session: { email: "", password: "" } }

    # 4. verify new sessions form returns proper status code + gets re-rendered
    assert_response :unprocessable_entity
    assert_template 'session/new'

    # 5. verify flash method appears
    assert_not flash.empty?

    # 6. visit another page, verify flash message DOESN'T appear on new page
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    # logout user
    delete logout_path
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with valid email/invalid password" do
    get login_path
    assert_template 'session/new'
    post login_path, params: { session: { email:    @user.email,
                                          password: "invalid" } }
    assert_not is_logged_in?
    assert_response :unprocessable_entity
    assert_template 'session/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end

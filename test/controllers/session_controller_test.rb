require "test_helper"

class SessionControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    #get session_new_url
    get login_path # new login route from routes.rb
    assert_response :success
  end
end

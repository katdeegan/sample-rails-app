require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    # verfies there are TWO such links on page (one each for logo + navigation menu element)
    assert_select "a[href=?]", root_path, count: 2

    # "a[href=?]" --> rails automatically inserts value of help_path in place of '?'
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

end

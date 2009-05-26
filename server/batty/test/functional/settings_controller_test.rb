
require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  def setup
    @yuya = users(:yuya)

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "settings"}

    assert_routing("/settings",              base.merge(:action => "index"))
    assert_routing("/settings/get_nickname", base.merge(:action => "get_nickname"))
    assert_routing("/settings/set_nickname", base.merge(:action => "set_nickname"))
  end

  test "GET index" do
    get :index

    assert_response(:success)
    assert_template("index")
    assert_flash_empty
    assert_logged_in(@yuya)
  end

  test "GET index, abnormal, no login" do
    session_logout

    get :index

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "XHR GET get_nickname" do
    xhr :get, :get_nickname

    assert_response(:success)
    assert_template(nil)
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya.nickname, @response.body)
  end

  test "XHR GET get_nickname, html" do
    @yuya.update_attributes!(:nickname => "<&>")

    xhr :get, :get_nickname

    assert_response(:success)
    assert_template(nil)
    assert_flash_empty

    assert_equal("<&>", @response.body)
  end

  test "GET get_nickname, abnormal, method not allowed" do
    get :get_nickname

    assert_response(405)
    assert_template(nil)
  end

  test "XHR GET get_nickname, abnormal, no login" do
    session_logout

    xhr :get, :get_nickname

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end
end

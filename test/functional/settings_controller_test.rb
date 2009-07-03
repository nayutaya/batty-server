
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

    assert_equal(@yuya.email_addresses.size, assigns(:email_addresses).size)
    assert_equal(true, assigns(:email_addresses).all? { |e| e.user == @yuya })
    assert_equal(
      assigns(:email_addresses).sort_by { |e| [e.email, e.id] },
      assigns(:email_addresses))
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

  test "XHR POST set_nickname" do
    nickname = "new-nickname"

    xhr :post, :set_nickname, :value => nickname

    assert_response(:success)
    assert_template(nil)
    assert_flash_empty
    assert_logged_in(@yuya)

    assigns(:login_user).reload
    assert_equal(nickname, assigns(:login_user).nickname)
    assert_equal(nickname, @response.body)
  end

  test "XHR POST set_nickname, html" do
    xhr :post, :set_nickname, :value => "<&>"

    assert_response(:success)
    assert_template(nil)
    assert_flash_empty

    assert_equal("&lt;&amp;&gt;", @response.body)
  end

  test "XHR POST set_nickname, invalid value" do
    xhr :post, :set_nickname, :value => "a" * (User::NicknameMaximumLength + 1)

    assert_response(422)
    assert_template(nil)
    assert_flash_empty

    assert_equal(
      ERB::Util.h(assigns(:login_user).errors.on(:nickname).to_s),
      @response.body)
  end

  test "POST set_nickname, abnormal, method not allowed" do
    post :set_nickname

    assert_response(405)
    assert_template(nil)
  end

  test "XHR GET set_nickname, abnormal, method not allowed" do
    xhr :get, :set_nickname

    assert_response(405)
    assert_template(nil)
  end

  test "XHR POST set_nickname, abnormal, no login" do
    session_logout

    xhr :post, :set_nickname

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end
end

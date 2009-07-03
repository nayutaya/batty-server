
require 'test_helper'

class CredentialsControllerTest < ActionController::TestCase
  def setup
    @yuya = users(:yuya)

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "credentials"}

    assert_routing("/credentials", base.merge(:action => "index"))
  end

  test "GET index" do
    get :index

    assert_response(:success)
    assert_template("index")
    assert_flash_empty
    assert_logged_in(@yuya)

    open_id_credentials = assigns(:open_id_credentials)
    assert_equal(@yuya.open_id_credentials.size, open_id_credentials.size)
    assert_equal(true, open_id_credentials.all? { |o| o.user == @yuya })
    assert_equal(
      open_id_credentials.sort_by(&:identity_url),
      open_id_credentials)

    email_credentials = assigns(:email_credentials)
    assert_equal(@yuya.email_credentials.size, email_credentials.size)
    assert_equal(true, email_credentials.all? { |e| e.user == @yuya})
    assert_equal(
      email_credentials.sort_by(&:email),
      email_credentials)
  end

  test "GET index, abnormal, no login" do
    session_logout

    get :index

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end
end


require 'test_helper'

class EmailSignupControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "email_signup"}

    assert_routing("/signup/email", base.merge(:action => "index"))
  end

  test "GET index" do
    session_login(users(:yuya))

    get :index

    assert_response(:success)
    assert_template("index")
    assert_flash_empty
    assert_not_logged_in

    assert_equal(
      EmailSignupForm.new.attributes,
      assigns(:signup_form).attributes)
  end
end

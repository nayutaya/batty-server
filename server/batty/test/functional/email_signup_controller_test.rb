
require 'test_helper'

class EmailSignupControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "email_signup"}

    assert_routing("/signup/email",                       base.merge(:action => "index"))
    assert_routing("/signup/email/validate",              base.merge(:action => "validate"))
    assert_routing("/signup/email/validated",             base.merge(:action => "validated"))
    assert_routing("/signup/email/create",                base.merge(:action => "create"))
    assert_routing("/signup/email/created",               base.merge(:action => "created"))
    assert_routing("/signup/email/activation/0123456789", base.merge(:action => "activation", :activation_token => "0123456789"))
    assert_routing("/signup/email/activation/abcdef",     base.merge(:action => "activation", :activation_token => "abcdef"))
    assert_routing("/signup/email/activate",              base.merge(:action => "activate"))
    assert_routing("/signup/email/activated",             base.merge(:action => "activated"))
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

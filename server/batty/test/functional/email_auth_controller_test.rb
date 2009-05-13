
require 'test_helper'

class EmailAuthControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "email_auth"}

    assert_routing("/auth/email",       base.merge(:action => "index"))
    assert_routing("/auth/email/login", base.merge(:action => "login"))
  end

  test "GET index" do
    get :index

    assert_response(:success)
    assert_template("index")
    # FIXME: flashのテスト

    assert_equal(
      EmailLoginForm.new.attributes,
      assigns(:login_form).attributes)
  end
end


require 'test_helper'

class EmailAuthControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "email_auth"}

    assert_routing("/auth/email",       base.merge(:action => "index"))
    assert_routing("/auth/email/login", base.merge(:action => "login"))
  end

  test "GET index" do
    session_login(users(:yuya))

    get :index

    assert_response(:success)
    assert_template("index")
    # FIXME: flashのテスト
    assert_not_logged_in

    assert_equal(
      EmailLoginForm.new.attributes,
      assigns(:login_form).attributes)
  end

  test "POST login" do
    login_form = EmailLoginForm.new(
      :email    => email_credentials(:yuya_gmail).email,
      :password => "yuya_gmail")

    post :login, :login_form => login_form.attributes

    assert_response(:redirect)
    assert_redirected_to(:controller => "auth", :action => "login_complete")
    # TODO: flashのテスト

    assert_equal(
      login_form.attributes,
      assigns(:login_form).attributes)
    assert_equal(true, assigns(:login_form).valid?)

    assert_equal(
      email_credentials(:yuya_gmail),
      assigns(:email_credential))
  end

  test "POST login, failed, inactive credential" do
    login_form = EmailLoginForm.new(
      :email    => email_credentials(:yuya_nayutaya).email,
      :password => "yuya_nayutaya")

    post :login, :login_form => login_form.attributes

    assert_response(:success)
    assert_template("index")
    # FIXME: flashのテスト

    # TODO: パスワードがエコーされないことを確認
    assert_equal(true, assigns(:login_form).valid?)
    assert_equal(nil, assigns(:email_credential))
  end

  test "POST login, invalid form" do
    login_form = EmailLoginForm.new

    post :login, :login_form => login_form.attributes

    assert_response(:success)
    assert_template("index")
    # FIXME: flashのテスト

    assert_equal(false, assigns(:login_form).valid?)
    assert_equal(nil, assigns(:email_credential))
  end
end

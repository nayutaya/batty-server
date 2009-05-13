
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
    assert_flash_empty
    assert_not_logged_in

    assert_equal(
      EmailLoginForm.new.attributes,
      assigns(:login_form).attributes)
  end

  test "POST login" do
    login_form = EmailLoginForm.new(
      :email    => email_credentials(:yuya_gmail).email,
      :password => "yuya_gmail")
    assert_equal(true, login_form.valid?)

    post :login, :login_form => login_form.attributes

    assert_response(:redirect)
    assert_redirected_to(:controller => "auth", :action => "login_complete")
    assert_flash_empty
    # TODO: セッションのテスト

    assert_equal(
      login_form.attributes,
      assigns(:login_form).attributes)

    assert_equal(
      email_credentials(:yuya_gmail),
      assigns(:email_credential))
  end

  test "POST login, failed, inactive credential" do
    login_form = EmailLoginForm.new(
      :email    => email_credentials(:yuya_nayutaya).email,
      :password => "yuya_nayutaya")
    assert_equal(true, login_form.valid?)

    post :login, :login_form => login_form.attributes

    assert_response(:success)
    assert_template("index")
    assert_flash_error

    # TODO: パスワードがエコーされないことを確認
    assert_equal(nil, assigns(:email_credential))
  end

  test "POST login, invalid form" do
    login_form = EmailLoginForm.new
    assert_equal(false, login_form.valid?)

    post :login, :login_form => login_form.attributes

    assert_response(:success)
    assert_template("index")
    assert_flash_error

    assert_equal(nil, assigns(:email_credential))
  end

  private

  def assert_flash_empty
    assert_nil(assigns(:flash_notice))
    assert_nil(assigns(:flash_error))
  end

=begin
  def assert_flash_notice
    assert_not_nil(assigns(:flash_notice))
    assert_nil(assigns(:flash_error))
  end
=end

  def assert_flash_error
    assert_nil(assigns(:flash_notice))
    assert_not_nil(assigns(:flash_error))
  end
end

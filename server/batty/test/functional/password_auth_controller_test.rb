
require 'test_helper'

class PasswordAuthControllerTest < ActionController::TestCase
  test "routes" do
    # TODO: 実装せよ
  end

  test "POST login, yuya_gmail" do
    assert_equal(nil, @request.session[:user_id])

    post :login, :email => email_credentials(:yuya_gmail).email, :password => "yuya_gmail"

    assert_response(:redirect)
    assert_redirected_to(:controller => "password_auth", :action => "login_complete")

    assert_equal(users(:yuya).id, @request.session[:user_id])
  end

  test "POST login, risa_example" do
    assert_equal(nil, @request.session[:user_id])

    post :login, :email => email_credentials(:risa_example).email, :password => "risa_example"

    assert_response(:redirect)
    assert_redirected_to(:controller => "password_auth", :action => "login_complete")

    assert_equal(users(:risa).id, @request.session[:user_id])
  end

  test "POST login, authentication failed" do
    assert_equal(nil, @request.session[:user_id])

    post :login, :email => email_credentials(:yuya_gmail).email, :password => "invalid"

    assert_response(:success)
    assert_template("login")

    assert_equal(nil, @request.session[:user_id])
  end

  test "GET login, abnormal, method not allowed" do
    get :login

    assert_response(405)
    assert_template(nil)
  end
end


require 'test_helper'

class AuthControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "auth"}

    assert_routing("/auth/login_complete",  base.merge(:action => "login_complete"))
    assert_routing("/auth/logout",          base.merge(:action => "logout"))
    assert_routing("/auth/logout_complete", base.merge(:action => "logout_complete"))
  end

  test "GET login_complete" do
    return_path = "/return"

    get :login_complete, :return_path => return_path

    assert_response(:success)
    assert_template("login_complete")

    assert_equal(return_path, assigns(:return_path))
  end

  test "GET login_complete, without return path" do
    get :login_complete

    assert_response(:success)
    assert_template("login_complete")

    assert_equal(root_path, assigns(:return_path))
  end

  test "POST logout" do
    @request.session[:user_id] = 0

    post :logout

    assert_response(:redirect)
    assert_redirected_to(:controller => "auth", :action => "logout_complete")

    assert_equal(nil, @request.session[:user_id])
  end

  test "GET logout, abnormal, method not allowed" do
    @request.session[:user_id] = 0

    get :logout

    assert_response(405)
    assert_template(nil)

    assert_equal(0, @request.session[:user_id])
  end

  test "GET logout_complete" do
    return_path = "/return"

    get :logout_complete, :return_path => return_path

    assert_response(:success)
    assert_template("logout_complete")

    assert_equal(return_path, assigns(:return_path))
  end

  test "GET logout_complete, without return path" do
    get :logout_complete

    assert_response(:success)
    assert_template("logout_complete")

    assert_equal(root_path, assigns(:return_path))
  end
end

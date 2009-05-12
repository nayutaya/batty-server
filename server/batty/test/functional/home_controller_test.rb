# -*- coding: utf-8 -*-

require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "home"}

    assert_routing("/", base.merge(:action => "index"))

    assert_equal("/", root_path)
  end

  test "GET index, yuya" do
    session_login(users(:yuya))

    get :index

    assert_response(:success)
    assert_template("index")
    assert_logged_in(users(:yuya))

    assert_equal(true, assigns(:devices).all? { |device| device.user == users(:yuya) })
    assert_equal(
      assigns(:devices).sort_by(&:name),
      assigns(:devices))
  end

  test "GET index, shinya" do
    session_login(users(:shinya))

    get :index

    assert_response(:success)
    assert_template("index")
    assert_logged_in(users(:shinya))
  end

  test "GET index, anonymous" do
    session_logout

    get :index

    assert_response(:success)
    assert_template("index")   
    assert_not_logged_in

    assert_equal(nil, assigns(:devices))
  end

  private

  def assert_logged_in(user)
    assert_equal(user.id, @request.session[:user_id])
    assert_equal(user, assigns(:login_user))
  end

  def assert_not_logged_in
    assert_equal(nil, @request.session[:user_id])
    assert_equal(nil, assigns(:login_user))
  end

  def session_login(user)
    @request.session[:user_id] = user.id
  end

  def session_logout
    @request.session[:user_id] = nil
  end
end

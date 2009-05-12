# -*- coding: utf-8 -*-

require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "home"}

    assert_routing("/", base.merge(:action => "index"))

    assert_equal("/", root_path)
  end

  test "GET index, yuya" do
    @request.session[:user_id] = users(:yuya).id

    get :index

    assert_response(:success)
    assert_template("index")

    assert_equal(users(:yuya), assigns(:login_user))

    assert_equal(true, assigns(:devices).all? { |device| device.user == users(:yuya) })
    assert_equal(
      assigns(:devices).sort_by(&:name),
      assigns(:devices))
  end

  test "GET index, shinya" do
    @request.session[:user_id] = users(:shinya).id

    get :index

    assert_response(:success)
    assert_template("index")

    assert_equal(users(:shinya), assigns(:login_user))
  end

  test "GET index, anonymous" do
    @request.session[:user_id] = nil

    get :index

    assert_response(:success)
    assert_template("index")
    
    assert_equal(nil, assigns(:login_user))

    assert_equal(nil, assigns(:devices))
  end
end

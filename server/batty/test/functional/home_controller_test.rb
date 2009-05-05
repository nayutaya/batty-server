# -*- coding: utf-8 -*-

require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "URI" do
    base = {:controller => "home"}

    assert_routing("/", base.merge(:action => "index"))
  end

  # FIXME 認証実装後、他のユーザでもテストする
  test "GET index by yu-yan" do
    get :index
    assert_response :success
    assert_template 'index'
    assert_equal(users(:yuya), assigns(:user))
    assert_equal(devices(:yuya_pda), assigns(:devices)[0])
    assert_equal(devices(:yuya_cellular), assigns(:devices)[1])
  end
end

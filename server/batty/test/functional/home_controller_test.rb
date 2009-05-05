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
    assert_equal('yu-yan', assigns(:user).nickname)
    assert_equal('Touch Diamond', assigns(:devices)[0].name)
    assert_equal('携帯電話', assigns(:devices)[1].name)
  end
end

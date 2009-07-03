# -*- coding: utf-8 -*-

require 'test_helper'

class Signup::OpenIdControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "signup/open_id"}

    assert_routing("signup/open_id",               base.merge(:action => "index"))
    assert_routing("signup/open_id/authenticate",  base.merge(:action => "authenticate"))
    assert_routing("signup/open_id/authenticated", base.merge(:action => "authenticated"))
    assert_routing("signup/open_id/create",        base.merge(:action => "create"))
    assert_routing("signup/open_id/created",       base.merge(:action => "created"))
  end

  test "GET index" do
    get :index

    assert_response(:success)
    assert_template("index")
  end

  test "POST authenticate, first step" do
    post :authenticate, :openid_url => "livedoor.com"

    assert_response(:redirect)
    # FXIME 検証を追加する？
    # FIXME 毎回リクエストが外に飛んでいるのをなんとかする
  end

  test "GET authenticate, second step" do
    get :authenticate, :openid_url => nil
    # TODO: 必要があれば検証を追加する
  end

  test "POST create" do
    @request.session[:identity_url] = "http://example.com/"

    post :create

    assert_response(:redirect)
    assert_redirected_to(:action => "created")
  end
end

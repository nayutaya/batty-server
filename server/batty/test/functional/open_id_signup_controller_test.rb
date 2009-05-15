# -*- coding: utf-8 -*-

require 'test_helper'

class OpenIdSignupControllerTest < ActionController::TestCase
  test "routes" do
    base = { :controller => "open_id_signup" }

    assert_routing("signup/openid",               base.merge(:action => "index"))
    assert_routing("signup/openid/authenticate",  base.merge(:action => "authenticate"))
    assert_routing("signup/openid/authenticated", base.merge(:action => "authenticated"))
    assert_routing("signup/openid/create",        base.merge(:action => "create"))
    assert_routing("signup/openid/created",       base.merge(:action => "created"))
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

# -*- coding: utf-8 -*-

require 'test_helper'

class Auth::OpenIdControllerTest < ActionController::TestCase
  def setup
    @shinya_example = open_id_credentials(:shinya_example)
  end

  test "routes" do
    base = {:controller => "auth/open_id"}

    assert_routing("/auth/open_id",       base.merge(:action => "index"))
    assert_routing("/auth/open_id/login", base.merge(:action => "login"))
  end

  test "GET index" do
    session_login(users(:yuya))

    get :index

    assert_response(:success)
    assert_template("index")
    assert_flash_empty
    assert_not_logged_in
  end

  test "POST login, successful with registered identity_url" do
    musha = Kagemusha.new(Auth::OpenIdController::Result)
    musha.def(:successful?) { true }
    musha.swap{
      post :login, :openid_url => @shinya_example.identity_url
    }
    assert_response(:redirect)
    assert_redirected_to('/')
    assert_equal('ログインしました。', @response.flash[:notice])
  end

  test "POST login, successful with unregistered identity_url" do
    musha = Kagemusha.new(Auth::OpenIdController::Result)
    musha.def(:successful?) { true }
    musha.swap{
      post :login, :openid_url => 'http://example.jp/yuya'
    }
    assert_response(:redirect)
    assert_redirected_to(:controller => 'signup/open_id', :action => 'index')
    assert_equal('OpenID がまだ登録されていません。', @response.flash[:notice])
  end

  [
   [:missing,  'OpenID サーバが見つかりませんでした。'],
   [:invalid,  'OpenID が不正です。'],
   [:canceled, 'OpenID の検証がキャンセルされました。'],
   [:failed,   'OpenID の検証が失敗しました。'],
  ].each do |status, message|
    test "POST login, #{status}" do
      musha = Kagemusha.new(Auth::OpenIdController::Result)
      musha.def(:successful?) { false }
      musha.def(:message) { message }
      musha.swap {
        post :login, :openid_url => @shinya_example.identity_url
      }
      assert_response(:redirect)
      assert_redirected_to('/')
      assert_equal(message, @response.flash[:error])
    end
  end

  test "GET login, abnormal, method not allowed" do
    get :login

    assert_response(405)
    assert_template(nil)
  end

end

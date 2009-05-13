# -*- coding: utf-8 -*-
require 'test_helper'

class OpenIdAuthControllerTest < ActionController::TestCase

  def setup
    @shinya_example = open_id_credentials(:shinya_example)
  end

  test "routes" do
    # TODO 実装せよ
  end

  test "POST login, successful with registered user" do
    musha = Kagemusha.new(OpenIdAuthController::Result)
    musha.def(:status) { :successful }
    musha.swap{
      post :login, :openid_url => @shinya_example.identity_url
      assert_response(:redirect)
      assert_redirected_to('/')
      assert_equal('ログインしました。', @response.flash[:notice])
    }
  end

  test "POST login, successful without registered user" do
    musha = Kagemusha.new(OpenIdAuthController::Result)
    musha.def(:status) { :successful }
    musha.swap{
      post :login, :openid_url => 'http://example.jp/yuya'
      assert_response(:redirect)
      assert_redirected_to(:controller => 'open_id_signup', :action => 'signup')
      assert_equal('OpenID がまだ登録されていません。', @response.flash[:notice])
    }
  end

  [
   [:missing,  'OpenID サーバが見つかりませんでした。'],
   [:invalid,  'OpenID が不正です。'],
   [:canceled, 'OpenID の検証がキャンセルされました。'],
   [:failed,   'OpenID の検証が失敗しました。'],
  ].each do |status, message|
    test "POST login, #{status}" do
      musha = Kagemusha.new(OpenIdAuthController::Result)
      musha.def(:status) { status }
      musha.swap {
        post :login, :openid_url => @shinya_example.identity_url
        assert_response(:redirect)
        assert_redirected_to('/')
        assert_equal(message, @response.flash[:error])
      }
    end
  end


end

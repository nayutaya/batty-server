
require 'test_helper'

class OpenIdSignupControllerTest < ActionController::TestCase
  test "routes" do
    # TODO: 実装せよ
  end

  test "GET index" do
    get :index

    assert_response(:success)
    assert_template("index")
  end

  test "POST authenticate, first step" do
    post :authenticate, :openid_url => "livedoor.com"

    assert_response(:redirect)
  end

  test "GET authenticate, second step" do
    get :authenticate, :openid_url => nil
  end

  test "POST signup" do
    post :signup

    assert_response(:redirect)
    assert_redirected_to(:controller => "open_id_signup", :action => "signup_complete")
  end
end

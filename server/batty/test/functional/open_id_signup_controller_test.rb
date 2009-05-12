
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
end

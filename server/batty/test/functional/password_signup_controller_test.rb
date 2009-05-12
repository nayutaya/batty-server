
require 'test_helper'

class PasswordSignupControllerTest < ActionController::TestCase
  test "routes" do
    # TODO:
  end

  test "GET index" do
    get :index

    assert_response(:success)
    assert_template("index")
  end

  test "POST confirm" do
    post :confirm, :credential => {:email => "a"}

    assert_response(:success)
    assert_template("confirm")
  end
end

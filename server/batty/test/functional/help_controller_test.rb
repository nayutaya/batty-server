
require 'test_helper'

class HelpControllerTest < ActionController::TestCase
  def setup
    @yuya = users(:yuya)
  end

  test "routes" do
    base = {:controller => "help"}

    assert_routing("/help",     base.merge(:action => "index"))
    assert_routing("/help/any", base.merge(:action => "any"))
  end

  test "GET index, logged in" do
    session_login(@yuya)

    get :index

    assert_response(:success)
    assert_template("index")
    assert_logged_in(@yuya)
  end

  test "GET index, no login" do
    session_logout

    get :index

    assert_response(:success)
    assert_template("index")
    assert_not_logged_in
  end

  test "GET keywords" do
    get :keywords

    assert_response(:success)
    assert_template("keywords")
  end
end

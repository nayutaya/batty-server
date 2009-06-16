
require 'test_helper'

class HelpControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "help"}

    assert_routing("/help",     base.merge(:action => "index"))
    assert_routing("/help/any", base.merge(:action => "any"))
  end

  test "GET index" do
    get :index

    assert_response(:success)
    assert_template("index")
  end
end

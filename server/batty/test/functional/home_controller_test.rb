
require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "URI" do
    base = {:controller => "home"}

    assert_routing("/", base.merge(:action => "index"))
  end
end

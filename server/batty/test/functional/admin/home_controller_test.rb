
require 'test_helper'

class Admin::HomeControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "admin/home"}

    assert_routing("/admin", base.merge(:action => "index"))
  end
end

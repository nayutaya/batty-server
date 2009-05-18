
require 'test_helper'

class DevicesControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "devices"}

    assert_routing("/devices/new",    base.merge(:action => "new"))
    assert_routing("/devices/create", base.merge(:action => "create"))

    assert_routing("/device/0123456789", base.merge(:action => "show", :device_token => "0123456789"))
    assert_routing("/device/abcdef",     base.merge(:action => "show", :device_token => "abcdef"))
  end
end

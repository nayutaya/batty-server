
require 'test_helper'

class DeviceApiControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "device_api"}

    assert_routing("/device/01234567/energies/update/01234",       base.merge(:action => "update_energy", :device_token => "01234567", :level => "01234"))
    assert_routing("/device/89abcdef/energies/update/56789",       base.merge(:action => "update_energy", :device_token => "89abcdef", :level => "56789"))
    assert_routing("/device/01234567/energies/update/01234/56789", base.merge(:action => "update_energy", :device_token => "01234567", :level => "01234", :time => "56789"))
    assert_routing("/device/89abcdef/energies/update/56789/01234", base.merge(:action => "update_energy", :device_token => "89abcdef", :level => "56789", :time => "01234"))
  end
end

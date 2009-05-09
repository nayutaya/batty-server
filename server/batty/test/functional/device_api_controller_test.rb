
require 'test_helper'

class DeviceApiControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "device_api"}

    assert_routing("/device/01234567/energies/update/01234",       base.merge(:action => "update_energy", :device_token => "01234567", :level => "01234"))
    assert_routing("/device/89abcdef/energies/update/56789",       base.merge(:action => "update_energy", :device_token => "89abcdef", :level => "56789"))
    assert_routing("/device/01234567/energies/update/01234/56789", base.merge(:action => "update_energy", :device_token => "01234567", :level => "01234", :time => "56789"))
    assert_routing("/device/89abcdef/energies/update/56789/01234", base.merge(:action => "update_energy", :device_token => "89abcdef", :level => "56789", :time => "01234"))
  end

  test "POST update_energy" do
    device = devices(:yuya_pda)

    post :update_energy, :device_token => device.device_token

    assert_response(:success)
    assert_template(nil)

    assert_equal(device, assigns(:device))
  end

  test "POST update_energy, abnormal, no device token" do
    post :update_energy, :device_token => nil

    assert_response(404)
    assert_template(nil)
  end
end

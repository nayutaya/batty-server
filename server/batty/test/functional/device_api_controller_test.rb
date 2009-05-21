
require 'test_helper'

class DeviceApiControllerTest < ActionController::TestCase
  def setup
    @yuya_pda = devices(:yuya_pda)
  end

  test "routes" do
    base = {:controller => "device_api"}

    assert_routing("/device/token/01234567/energies/update/01234",       base.merge(:action => "update_energy", :device_token => "01234567", :level => "01234"))
    assert_routing("/device/token/89abcdef/energies/update/56789",       base.merge(:action => "update_energy", :device_token => "89abcdef", :level => "56789"))
    assert_routing("/device/token/01234567/energies/update/01234/56789", base.merge(:action => "update_energy", :device_token => "01234567", :level => "01234", :time => "56789"))
    assert_routing("/device/token/89abcdef/energies/update/56789/01234", base.merge(:action => "update_energy", :device_token => "89abcdef", :level => "56789", :time => "01234"))
  end

  test "POST update_energy" do
    device = @yuya_pda
    level  = 50
    time   = Time.local(2009, 1, 1)

    called = false
    musha = Kagemusha.new(Device)
    musha.def(:update_energy) { |options|
      raise unless self == device
      raise unless options[:observed_level] == level
      raise unless options[:observed_at]    == time
      raise unless options[:update_event]   == true
      called = true
      nil
    }

    musha.swap {
      Kagemusha::DateTime.at(time) {
        post :update_energy, :device_token => device.device_token, :level => level.to_s
      }
    }

    assert_response(:success)
    assert_template(nil)

    assert_equal(device, assigns(:device))
    assert_equal(level,  assigns(:level))
    assert_equal(time,   assigns(:time))

    assert_equal(true, called)
  end

  test "POST update_energy, min level" do
    post :update_energy, :device_token => @yuya_pda.device_token, :level => "0"

    assert_response(:success)
    assert_template(nil)
    
    assert_equal(0, assigns(:level))
  end

  test "POST update_energy, max level" do
    post :update_energy, :device_token => @yuya_pda.device_token, :level => "100"

    assert_response(:success)
    assert_template(nil)

    assert_equal(100, assigns(:level))
  end

  test "POST update_energy, with time" do
    post :update_energy, :device_token => @yuya_pda.device_token, :level => "0", :time => "19870605040302"

    assert_response(:success)
    assert_template(nil)

    assert_equal(Time.local(1987, 6, 5, 4, 3, 2), assigns(:time))
  end

  test "POST update_energy, abnormal, no device token" do
    post :update_energy, :device_token => nil

    assert_response(404)
    assert_template(nil)
  end

  test "POST update_energy, abnormal, no level" do
    post :update_energy, :device_token => @yuya_pda.device_token, :level => nil

    assert_response(404)
    assert_template(nil)
  end

  test "POST update_energy, abnormal, invalid level char" do
    post :update_energy, :device_token => @yuya_pda.device_token, :level => "x"

    assert_response(404)
    assert_template(nil)
  end

  test "POST update_energy, abnormal, level is too big" do
    post :update_energy, :device_token => @yuya_pda.device_token, :level => "101"

    assert_response(404)
    assert_template(nil)
  end

  test "POST update_energy, abnormal, invalid time char" do
    post :update_energy, :device_token => @yuya_pda.device_token, :level => "0", :time => "x"

    assert_response(404)
    assert_template(nil)
  end

  test "POST update_energy, abnormal, invalid time" do
    post :update_energy, :device_token => @yuya_pda.device_token, :level => "0", :time => "99999999999999"

    assert_response(404)
    assert_template(nil)
  end

  test "GET update_energy, abnormal, not allowed method" do
    get :update_energy, :device_token => @yuya_pda.device_token, :level => "0"

    assert_response(405)
    assert_template(nil)
  end
end

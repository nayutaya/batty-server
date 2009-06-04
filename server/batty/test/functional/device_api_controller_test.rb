
require 'test_helper'

class DeviceApiControllerTest < ActionController::TestCase
  def setup
    @yuya_pda = devices(:yuya_pda)
  end

  test "routes" do
    base = {:controller => "device_api"}

    assert_routing("/device/token/0123456789abcdef/energies/update/1234567890",            base.merge(:action => "update_energy", :device_token => "0123456789abcdef", :level => "1234567890"))
    assert_routing("/device/token/0123456789abcdef/energies/update/1234567890/2345678901", base.merge(:action => "update_energy", :device_token => "0123456789abcdef", :level => "1234567890", :time => "2345678901"))
  end

  test "POST update_energy" do
    level = 50
    time  = Time.local(2009, 1, 1)

    assert_difference("Energy.count", +1) {
      Kagemusha::DateTime.at(time) {
        post :update_energy, :device_token => @yuya_pda.device_token, :level => level.to_s
      }
    }

    assert_response(:success)
    assert_template(nil)
    assert_flash_empty

    assert_equal(@yuya_pda, assigns(:device))

    assert_equal(true,  assigns(:api_form).valid?)
    assert_equal(level, assigns(:api_form).level)
    assert_equal(time,  assigns(:api_form).parsed_time)

    assert_equal(@yuya_pda, assigns(:energy).device)
    assert_equal(level,     assigns(:energy).observed_level)
    assert_equal(time,      assigns(:energy).observed_at)
  end

  test "POST update_energy, with time" do
    assert_difference("Energy.count", +1) {
      post :update_energy, :device_token => @yuya_pda.device_token, :level => "0", :time => "19870605040302"
    }

    assert_response(:success)
    assert_template(nil)
    assert_flash_empty

    assert_equal(0, assigns(:energy).observed_level)
    assert_equal(Time.local(1987, 6, 5, 4, 3, 2), assigns(:energy).observed_at)
  end

  test "POST update_energy, invalid form" do
    post :update_energy, :device_token => @yuya_pda.device_token, :level => "999"

    assert_response(422)
    assert_template(nil)
    assert_flash_empty

    assert_equal(false, assigns(:api_form).valid?)
  end

  test "GET update_energy, abnormal, method not allowed" do
    get :update_energy, :device_token => @yuya_pda.device_token, :level => "0"

    assert_response(405)
    assert_template(nil)
    assert_flash_empty
  end

  test "POST update_energy, abnormal, invalid device token" do
    post :update_energy, :device_token => "0", :level => "0"

    assert_response(404)
    assert_template(nil)
    assert_flash_empty
  end
end

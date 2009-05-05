
require 'test_helper'

class DeviceIconTest < ActiveSupport::TestCase
  def setup
    @pda      = device_icons(:pda)
    @cellular = device_icons(:cellular)
  end

  #
  # 関連
  #

  test "has many devices" do
    expected = [
      devices(:yuya_pda),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @pda.devices.all(:order => "devices.id ASC"))

    expected = [
      devices(:yuya_cellular),
      devices(:shinya_cellular),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @cellular.devices.all(:order => "devices.id ASC"))
  end
end


require 'test_helper'

class EnergyTest < ActiveSupport::TestCase
  def setup
  end

  #
  # 関連
  #

  test "belongs to device" do
    assert_equal(
      devices(:yuya_pda),
      energies(:yuya_pda1).device)

    assert_equal(
      devices(:shinya_note),
      energies(:shinya_note1).device)
  end
end

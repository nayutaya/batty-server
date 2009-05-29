
require 'test_helper'

class EventBuilderTest < ActiveSupport::TestCase
  def setup
    @module = EventBuilder

    @yuya_pda      = devices(:yuya_pda)
    @yuya_cellular = devices(:yuya_cellular)
    @shinya_note   = devices(:shinya_note)
  end

  #
  # クラスメソッド
  #

  test "self.build, yuya_pda" do
    device = @yuya_pda
    Event.delete_all(:device_id => device.id)
    Energy.delete_all(:device_id => device.id)

    count = 0
    create_energy = proc { |level|
      Energy.create!(:device_id => device.id, :observed_level => level, :observed_at => Time.local(2009, 1, 1) + (count += 1))
    }

    e1 = create_energy[0]

    events = @module.build(device)
    assert_equal(0, events.size)

    e2 = create_energy[0]

    events = @module.build(device)
    assert_equal(0, events.size)

    e3 = create_energy[100]

    events = @module.build(device)
    assert_equal(2, events.size)

    event1, event2 = events

    t1, t2 = [triggers(:yuya_pda_ge90), triggers(:yuya_pda_eq100)].sort_by(&:id)

    assert_equal(device.id, event1.device_id)
    assert_equal(t1.id,     event1.trigger_id)

    assert_equal(device.id, event2.device_id)
    assert_equal(t2.id,     event2.trigger_id)
  end
end

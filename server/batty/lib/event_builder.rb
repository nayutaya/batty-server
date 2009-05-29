
# イベント構築
module EventBuilder
  def self.build(device)
    current_energies = device.current_two_energies
    current_energy   = current_energies.first
    return [] if current_energies.size < 2

    level1, level2 = current_energies.map(&:observed_level)
    fired_triggers = device.fired_triggers(level1, level2)
    return [] if fired_triggers.empty?

    return fired_triggers.
      map { |trigger| [trigger, {:device_id => device.id, :trigger_id => trigger.id, :energy_id => current_energy.id}] }.
      map { |trigger, keys|
        attrs = keys.dup
        attrs.merge!(trigger.to_event_hash)
        attrs.merge!(current_energy.to_event_hash)
        attrs
        Event.create!(attrs)
      }
  end
end

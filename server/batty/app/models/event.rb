# == Schema Information
# Schema version: 20090529051529
#
# Table name: events
#
#  id               :integer       not null, primary key
#  created_at       :datetime      not null
#  device_id        :integer       not null, index_events_on_device_id
#  trigger_operator :integer       not null
#  trigger_level    :integer       not null
#  observed_level   :integer       not null
#  observed_at      :datetime      not null, index_events_on_observed_at
#  trigger_id       :integer       index_events_on_trigger_id
#  energy_id        :integer       index_events_on_energy_id
#

# イベント
class Event < ActiveRecord::Base
  belongs_to :device
  belongs_to :trigger
  belongs_to :energy

  validates_presence_of :device_id
  validates_presence_of :trigger_operator
  validates_presence_of :trigger_level
  validates_presence_of :observed_level
  validates_presence_of :observed_at
  validates_inclusion_of :trigger_operator, :in => 0..5, :allow_nil => true
  validates_inclusion_of :trigger_level, :in => Energy::LevelRange, :allow_nil => true
  validates_inclusion_of :observed_level, :in => Energy::LevelRange, :allow_nil => true

  def self.cleanup(device, limit)
    raise(ArgumentError) if limit < 1

    oldest = device.events.first(
      :order  => "events.observed_at DESC, events.id DESC",
      :offset => (limit - 1))

    if oldest
      self.destroy_all([
        "(events.device_id = :device_id) AND (events.observed_at < :time)",
        {:device_id => device.id, :time => oldest.observed_at}])
    end

    return nil
  end

  def trigger_operator_symbol
    return Trigger.operator_code_to_symbol(self.trigger_operator)
  end

  def trigger_operator_sign
    return Trigger.operator_code_to_sign(self.trigger_operator)
  end
end

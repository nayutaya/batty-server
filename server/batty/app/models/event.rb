# == Schema Information
# Schema version: 20090519031040
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
#

# イベント
class Event < ActiveRecord::Base
  belongs_to :device

  validates_presence_of :device_id
  validates_presence_of :trigger_operator
  validates_presence_of :trigger_level
  validates_presence_of :observed_level
  validates_presence_of :observed_at
  validates_inclusion_of :trigger_operator, :in => 0..5, :allow_nil => true
  validates_inclusion_of :trigger_level, :in => Energy::LevelRange, :allow_nil => true
  validates_inclusion_of :observed_level, :in => Energy::LevelRange, :allow_nil => true

  def trigger_operator_symbol
    return Trigger.operator_code_to_symbol(self.trigger_operator)
  end

  def trigger_operator_sign
    return Trigger.operator_code_to_sign(self.trigger_operator)
  end
end

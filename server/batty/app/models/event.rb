# == Schema Information
# Schema version: 20090420021540
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

  # TODO: device_idの存在を検証
  # TODO: trigger_operatorの存在を検証
  # TODO: trigger_operatorの範囲を検証
  # TODO: trigger_levelの存在を検証
  # TODO: trigger_levelの範囲を検証
  # TODO: observed_levelの存在を検証
  # TODO: observed_levelの範囲を検証
  # TODO: observed_atの存在を検証

  def trigger_operator_symbol
    return Trigger.operator_code_to_symbol(self.trigger_operator)
  end

  def trigger_operator_sign
    return Trigger.operator_code_to_sign(self.trigger_operator)
  end
end

# == Schema Information
# Schema version: 20090529051529
#
# Table name: active_forms
#
#  enable   :boolean
#  operator :integer
#  level    :integer
#

# トリガ編集フォーム
class TriggerEditForm < ActiveForm
  LevelRange = Energy::LevelRange

  column :enable,   :type => :boolean
  column :operator, :type => :integer
  column :level,    :type => :integer

  N_("TriggerEditForm|Enable")
  N_("TriggerEditForm|Operator")
  N_("TriggerEditForm|Level")

  validates_presence_of :operator,
    :message => "%{fn}を選択してください。"
  validates_presence_of :level
  validates_numericality_of :operator, :only_integer => true, :allow_nil => true
  validates_numericality_of :level, :only_integer => true, :allow_nil => true
  validates_inclusion_of :operator, :in => Trigger::OperatorCodes, :allow_nil => true,
    :message => "%{fn}を選択してください。"
  validates_inclusion_of :level, :in => LevelRange, :allow_nil => true,
    :message => "%{fn}は#{LevelRange.begin}～#{LevelRange.end}で入力してください。"

  def self.operators_for_select(options = {})
    options = options.dup
    include_blank = (options.delete(:include_blank) == true)
    raise(ArgumentError) unless options.empty?

    return Trigger.operators_for_select(
      :include_blank => include_blank,
      :blank_label   => "(選択してください)")
  end

  def to_trigger_hash
    return {
      :enable   => self.enable,
      :operator => self.operator,
      :level    => self.level,
    }
  end
end

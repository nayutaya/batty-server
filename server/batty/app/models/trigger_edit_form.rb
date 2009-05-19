
# トリガ編集フォーム
class TriggerEditForm < ActiveForm
  column :enable,   :type => :boolean
  column :operator, :type => :integer
  column :level,    :type => :integer

  validates_presence_of :enable
  validates_presence_of :operator
  validates_presence_of :level
  validates_inclusion_of :operator, :in => Trigger::OperatorCodes, :allow_nil => true
  validates_inclusion_of :level, :in => Energy::LevelRange, :allow_nil => true

  def self.operators_for_select
    items  = []
    items += Trigger::OperatorCodes.map { |code|
      name  = Trigger.operator_code_to_sign(code)
      name += " "
      name += Trigger.operator_code_to_description(code)
      [name, code.to_s]
    }
    return items
  end

  def to_trigger_hash
    return {
      :enable   => self.enable,
      :operator => self.operator,
      :level    => self.level,
    }
  end
end


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

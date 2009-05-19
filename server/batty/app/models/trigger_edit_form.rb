
# トリガ編集フォーム
class TriggerEditForm < ActiveForm
  column :enable,   :type => :boolean
  column :operator, :type => :integer
  column :level,    :type => :integer

  validates_presence_of :enable
  validates_presence_of :operator
  validates_presence_of :level
  validates_inclusion_of :operator, :in => 0..5, :allow_nil => true
  validates_inclusion_of :level, :in => 0..100, :allow_nil => true
end

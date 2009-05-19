
# トリガ編集フォーム
class TriggerEditForm < ActiveForm
  column :enable,   :type => :boolean
  column :operator, :type => :integer
  column :level,    :type => :integer
end

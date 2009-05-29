
# エネルギー更新APIフォーム
class UpdateEnergyApiForm < ActiveForm
  column :level, :type => :integer
  column :time,  :type => :integer
end

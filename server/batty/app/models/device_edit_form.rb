
# デバイス編集フォーム
class DeviceEditForm < ActiveForm
  column :name,           :type => :text
  column :device_icon_id, :type => :integer

  validates_presence_of :name
  validates_presence_of :device_icon_id
  # FIXME: デバイス名の最大長を定数化（Deviceクラス）
  validates_length_of :name, :maximum => 50, :allow_nil => true
  # FIXME: device_icon_idの実態の存在を確認

  def device_icon
    return DeviceIcon.find_by_id(self.device_icon_id)
  end

  def to_device_hash
    return {
      :name           => self.name,
      :device_icon_id => self.device_icon_id,
    }
  end
end

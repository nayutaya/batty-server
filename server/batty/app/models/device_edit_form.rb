
# デバイス編集フォーム
class DeviceEditForm < ActiveForm
  column :name,           :type => :text
  column :device_icon_id, :type => :integer

  def to_device_hash
    return {
      :name           => self.name,
      :device_icon_id => self.device_icon_id,
    }
  end
end

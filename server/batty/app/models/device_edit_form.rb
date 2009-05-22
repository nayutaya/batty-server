# == Schema Information
# Schema version: 20090522102421
#
# Table name: active_forms
#
#  name           :text
#  device_icon_id :integer
#

# デバイス編集フォーム
class DeviceEditForm < ActiveForm
  column :name,           :type => :text
  column :device_icon_id, :type => :integer

  validates_presence_of :name
  validates_presence_of :device_icon_id
  # FIXME: デバイス名の最大長を定数化（Deviceクラス）
  validates_length_of :name, :maximum => 50, :allow_nil => true
  validates_each :device_icon_id do |record, attr, value|
    unless record.device_icon
      # FIXME: エラーメッセージを指定せよ
      record.errors.add(attr)
    end
  end

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

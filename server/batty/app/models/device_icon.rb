# == Schema Information
# Schema version: 20090420021540
#
# Table name: device_icons
#
#  id            :integer       not null, primary key
#  created_at    :datetime      not null
#  updated_at    :datetime      not null
#  display_order :integer       not null, index_device_icons_on_display_order
#  name          :string(30)    not null
#  url16         :string(200)   not null
#  url32         :string(200)   not null
#

# デバイスアイコン
class DeviceIcon < ActiveRecord::Base
  has_many :devices

  # TODO: display_orderの存在を検証
  # TODO: nameの存在を検証
  # TODO: nameの文字数を検証
  # TODO: url16の存在を検証
  # TODO: url16の文字数を検証
  # TODO: url16のフォーマットを検証
  # TODO: url32の存在を検証
  # TODO: url32の文字数を検証
  # TODO: url32のフォーマットを検証
end

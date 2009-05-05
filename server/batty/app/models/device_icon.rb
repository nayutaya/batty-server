
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

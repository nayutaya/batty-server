
# デバイス
class Device < ActiveRecord::Base
  has_many :energies
  has_many :triggers
  has_many :events
  belongs_to :user
  belongs_to :device_icon

  # TODO: nameの存在を検証
  # TODO: nameの文字数を検証
  # TODO: device_tokenの存在を検証
  # TODO: device_tokenのフォーマットを検証

  # TODO: device_tokenを生成するメソッドを実装
  # TODO: 一意なdevice_tokenを生成するメソッドを実装
end


# エネルギー
class Energy < ActiveRecord::Base
  belongs_to :device

  # TODO: observed_levelの存在を検証
  # TODO: observed_levelの範囲を検証
  # TODO: observed_atの存在を検証

  # TODO: Eventモデルに変換するためのハッシュを生成するインスタンスメソッドを実装
end

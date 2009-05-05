
# ユーザ
class User < ActiveRecord::Base
  has_many :open_id_credentials
  has_many :email_credentials
  has_many :devices
  has_many :energies, :through => :devices
  has_many :events, :through => :devices

  # TODO: EmailAddressモデルとの関連を実装

  # TODO: nicknameの文字数を検証
  # TODO: user_tokenの存在を検証
  # TODO: user_tokenのフォーマットを検証

  # TODO: user_tokenを生成するメソッドを実装
  # TODO: 一意なuser_tokenを生成するメソッドを実装
end

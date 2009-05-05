
# メールログイン情報
class EmailCredential < ActiveRecord::Base
  belongs_to :user

  # TODO: emailの存在を検証
  # TODO: emailの文字数を検証
  # TODO: emailのフォーマットを検証
  # TODO: hashed_passwordの存在を検証
  # TODO: hashed_passwordのフォーマットを検証
  # TODO: activation_tokenの存在を検証
  # TODO: activation_tokenのフォーマットを検証

  # TODO: パスワードをハッシュするメソッドを実装
  # TODO: activation_tokenを生成するメソッドを実装
  # TODO: 一意なactivation_tokenを生成するメソッドを実装
end

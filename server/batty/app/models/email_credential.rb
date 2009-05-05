# == Schema Information
# Schema version: 20090420021540
#
# Table name: email_credentials
#
#  id               :integer       not null, primary key
#  created_at       :datetime      not null, index_email_credentials_on_created_at
#  activation_token :string(40)    not null, index_email_credentials_on_activation_token(unique)
#  user_id          :integer       not null, index_email_credentials_on_user_id
#  email            :string(200)   not null, index_email_credentials_on_email(unique)
#  hashed_password  :string(40)    not null
#  activated_at     :datetime      index_email_credentials_on_activated_at
#  loggedin_at      :datetime      
#


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

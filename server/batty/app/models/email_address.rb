# == Schema Information
# Schema version: 20090518160518
#
# Table name: email_addresses
#
#  id               :integer       not null, primary key
#  created_at       :datetime      not null, index_email_addresses_on_created_at
#  activation_token :string(40)    not null, index_email_addresses_on_activation_token(unique)
#  user_id          :integer       not null, index_email_addresses_on_email_and_user_id(unique) index_email_addresses_on_user_id
#  email            :string(200)   not null, index_email_addresses_on_email_and_user_id(unique)
#  activated_at     :datetime      index_email_addresses_on_activated_at
#

# メールアドレス
class EmailAddress < ActiveRecord::Base
  belongs_to :user

  # TODO: emailの存在を検証
  # TODO: emailの文字数を検証
  # TODO: emailのフォーマットを検証
  # TODO: activation_tokenの存在を検証
  # TODO: activation_tokenのフォーマットを検証

  # TODO: activation_tokenを生成するメソッドを実装
  # TODO: 一意なactivation_tokenを生成するメソッドを実装
end

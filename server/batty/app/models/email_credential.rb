# -*- coding: utf-8 -*-
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

  attr_accessor :password

  validates_presence_of :email
  validates_presence_of :activation_token
  validates_length_of :email, :maximum => 200, :allow_nil => true
  validates_format_of :activation_token, :with => TokenUtil.create_token_regexp(20), :allow_nil => true

  # TODO: emailのフォーマットを検証 <- 保留
  # TODO: password の存在を確認
  # TODO: hashed_passwordの存在を検証
  # TODO: hashed_passwordのフォーマットを検証

  # TODO: パスワードをハッシュするメソッドを実装
  # TODO: activation_tokenを生成するメソッドを実装
  # TODO: 一意なactivation_tokenを生成するメソッドを実装
end

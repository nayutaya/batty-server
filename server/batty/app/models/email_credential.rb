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

  TokenLength  = 20
  TokenPattern = TokenUtil.create_token_regexp(TokenLength)

  validates_presence_of :email
  validates_presence_of :activation_token
  validates_presence_of :hashed_password
  validates_length_of :email, :maximum => 200, :allow_nil => true
  validates_format_of :activation_token, :with => TokenPattern, :allow_nil => true
  validates_format_of :hashed_password, :with => /\A[0-9a-f]{40}\z/, :allow_nil => true
  # TODO: emailのフォーマットを検証 <- 保留
  # TODO: password の存在を確認

  def self.create_unique_activation_token
    return TokenUtil.create_unique_token(self, :activation_token, TokenLength)
  end

  def self.create_hashed_password(password)
    return Digest::SHA1.hexdigest("batty:" + password)
  end
end

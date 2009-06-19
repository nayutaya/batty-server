# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20090529051529
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

# 通知先メールアドレス
class EmailAddress < ActiveRecord::Base
  belongs_to :user

  TokenLength  = 20
  TokenPattern = TokenUtil.create_token_regexp(TokenLength)
  MaximumRecordsPerUser = 10

  validates_presence_of :activation_token
  validates_presence_of :user_id
  validates_presence_of :email
  validates_length_of :email, :maximum => 200
  validates_format_of :activation_token, :with => TokenPattern, :allow_nil => true
  validates_email_format_of :email, :message => "%{fn}は有効なメールアドレスではありません。"
  validates_uniqueness_of :activation_token
  validates_uniqueness_of :email, :scope => [:user_id]
  validates_each(:user_id, :on => :create) { |record, attr, value|
    if record.user && record.user.email_addresses(true).size >= MaximumRecordsPerUser
      record.errors.add(attr, "これ以上%{fn}に#{_(record.class.to_s.downcase)}を追加できません。")
    end
  }

  named_scope :active, :conditions => ["(email_addresses.activated_at IS NOT NULL)"]

  def self.create_unique_activation_token
    return TokenUtil.create_unique_token(self, :activation_token, TokenLength)
  end

  def activated?
    return !self.activated_at.nil?
  end

  def activate!
    return false if self.activated?
    self.update_attributes!(:activated_at => Time.now)
    return true
  end
end

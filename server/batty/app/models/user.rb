# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20090420021540
#
# Table name: users
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  updated_at :datetime      not null
#  user_token :string(40)    not null, index_users_on_user_token(unique)
#  nickname   :string(40)    
#

# ユーザ
class User < ActiveRecord::Base
  has_many :open_id_credentials
  has_many :email_credentials
  has_many :devices
  has_many :energies, :through => :devices
  has_many :events, :through => :devices
  has_many :email_addresses

  TokenLength  = 20
  TokenPattern = TokenUtil.create_token_regexp(TokenLength)

  validates_presence_of :user_token
  validates_length_of :nickname, :maximum => 40, :allow_nil => true
  validates_format_of :user_token, :with => TokenPattern

  def self.create_unique_user_token
    return TokenUtil.create_unique_token(self, :user_token, TokenLength)
  end
end

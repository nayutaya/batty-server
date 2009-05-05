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

  # TODO: EmailAddressモデルとの関連を実装

  validates_presence_of :user_token
  validates_length_of :nickname, :maximum => 40, :allow_nil => true
  # TODO: user_tokenのフォーマットを検証

  # TODO: user_tokenを生成するメソッドを実装
  # TODO: 一意なuser_tokenを生成するメソッドを実装
end

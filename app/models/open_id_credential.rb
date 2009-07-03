# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20090529051529
#
# Table name: open_id_credentials
#
#  id           :integer       not null, primary key
#  created_at   :datetime      not null
#  user_id      :integer       not null, index_open_id_credentials_on_user_id
#  identity_url :string(200)   not null, index_open_id_credentials_on_identity_url(unique)
#  loggedin_at  :datetime
#

# OpenID認証情報
class OpenIdCredential < ActiveRecord::Base
  MaximumRecordsPerUser = 10

  belongs_to :user

  validates_presence_of :identity_url
  validates_length_of :identity_url, :maximum => 200, :allow_nil => true
  validates_format_of :identity_url, :with => URI.regexp(%w[http https]), :allow_nil => true
  validates_uniqueness_of :identity_url
  validates_each(:user_id, :on => :create) { |record, attr, value|
    if record.user && record.user.open_id_credentials(true).size >= MaximumRecordsPerUser
      record.errors.add(attr, "これ以上%{fn}に#{_(record.class.to_s.downcase)}を追加できません。")
    end
  }

  def login!
    self.update_attributes!(:loggedin_at => Time.now)
  end
end

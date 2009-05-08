# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20090420021540
#
# Table name: open_id_credentials
#
#  id           :integer       not null, primary key
#  created_at   :datetime      not null
#  user_id      :integer       not null, index_open_id_credentials_on_user_id
#  identity_url :string(200)   not null, index_open_id_credentials_on_identity_url(unique)
#  loggedin_at  :datetime      
#

# OpenIDログイン情報
class OpenIdCredential < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :identity_url
  validates_length_of :identity_url, :maximum => 200

  # TODO: identity_urlのフォーマットを検証
end

# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20090529051529
#
# Table name: active_forms
#
#  email :text
#

# メールアドレス編集フォーム
class EmailAddressEditForm < ActiveForm
  column :email, :type => :text

  N_("EmailAddressEditForm|Email")

  validates_presence_of :email
  validates_length_of :email, :maximum => 200, :allow_nil => true
  validates_email_format_of :email, :message => "%{fn}は有効なメールアドレスではありません。"

  def to_email_address_hash
    return {
      :email => self.email,
    }
  end
end

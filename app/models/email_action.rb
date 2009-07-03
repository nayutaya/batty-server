# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20090529051529
#
# Table name: email_actions
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  updated_at :datetime      not null
#  trigger_id :integer       not null, index_email_actions_on_trigger_id
#  enable     :boolean       not null, index_email_actions_on_enable
#  email      :string(200)   not null
#  subject    :string(200)   not null
#  body       :text
#

# メールアクション
class EmailAction < ActiveRecord::Base
  MaximumRecordsPerTrigger = 5

  belongs_to :trigger

  validates_presence_of :trigger_id
  validates_presence_of :email
  validates_presence_of :subject
  validates_presence_of :body
  validates_length_of :email, :maximum => 200, :allow_nil => true
  validates_length_of :subject, :maximum => 200, :allow_nil => true
  validates_length_of :body, :maximum => 1000, :allow_nil => true
  validates_email_format_of :email,
    :message => "%{fn}は有効なメールアドレスではありません。"
  validates_each(:trigger_id, :on => :create) { |record, attr, value|
    if record.trigger && record.trigger.email_actions(true).size >= MaximumRecordsPerTrigger
      record.errors.add(attr, "これ以上%{fn}に#{_(record.class.to_s.downcase)}を追加できません。")
    end
  }
  validates_each(:email) { |record, attr, value|
    user = record.trigger.try(:device).try(:user)
    if user && !user.email_addresses.active.exists?(:email => record.email)
      record.errors.add(attr, :invalid)
    end
  }

  named_scope :enable, :conditions => {:enable => true}
end

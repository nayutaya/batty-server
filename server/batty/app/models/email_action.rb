# == Schema Information
# Schema version: 20090420021540
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
  belongs_to :trigger

  # TODO: trigger_idの存在を検証
  # TODO: emailの存在を検証
  # TODO: emailの文字数を検証
  # TODO: emailのフォーマットを検証
  # TODO: subjectの存在を検証
  # TODO: subjectの文字数を検証
  # TODO: bodyの存在を検証
  # TODO: bodyの文字数を検証（1000文字くらい？）
end

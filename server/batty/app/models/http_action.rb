# == Schema Information
# Schema version: 20090522102421
#
# Table name: http_actions
#
#  id          :integer       not null, primary key
#  created_at  :datetime      not null
#  updated_at  :datetime      not null
#  trigger_id  :integer       not null, index_http_actions_on_trigger_id
#  enable      :boolean       not null, index_http_actions_on_enable
#  http_method :string(10)    not null
#  url         :string(200)   not null
#  body        :text
#

class HttpAction < ActiveRecord::Base
end

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

# HTTPアクション
class HttpAction < ActiveRecord::Base
  UrlMaximumLength  = 200
  BodyMaximumLength = 1000

  belongs_to :trigger

  validates_presence_of :trigger_id
  validates_presence_of :http_method
  validates_presence_of :url
  validates_length_of :url, :maximum => UrlMaximumLength, :allow_nil => true
  validates_length_of :body, :maximum => BodyMaximumLength, :allow_nil => true
  validates_inclusion_of :http_method, :in => %w[HEAD GET POST], :allow_nil => true
  validates_format_of :url, :with => URI.regexp(["http"]), :allow_nil => true
end

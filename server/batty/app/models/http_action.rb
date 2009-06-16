# == Schema Information
# Schema version: 20090529051529
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
  HttpMethods = %w[HEAD GET POST].freeze.each(&:freeze)
  MaximumRecordsPerTrigger = 5

  belongs_to :trigger

  validates_presence_of :trigger_id
  validates_presence_of :http_method
  validates_presence_of :url
  validates_length_of :url, :maximum => UrlMaximumLength, :allow_nil => true
  validates_length_of :body, :maximum => BodyMaximumLength, :allow_nil => true
  validates_inclusion_of :http_method, :in => HttpMethods, :allow_nil => true
  validates_format_of :url, :with => URI.regexp(["http"]), :allow_nil => true
  validates_each(:trigger_id, :on => :create) { |record, attr, value|
    if record.trigger && record.trigger.http_actions(true).size >= MaximumRecordsPerTrigger
      record.errors.add(attr, "これ以上%{fn}に#{_(record.class.to_s.downcase)}を追加できません。")
    end
  }

  named_scope :enable, :conditions => {:enable => true}

  def self.http_methods_for_select(options = {})
    options = options.dup
    include_blank = (options.delete(:include_blank) == true)
    blank_label   = (options.delete(:blank_label) || "")
    raise(ArgumentError) unless options.empty?

    items  = []
    items += [[blank_label, nil]] if include_blank
    items += HttpMethods.map { |name| [name, name] }

    return items
  end
end

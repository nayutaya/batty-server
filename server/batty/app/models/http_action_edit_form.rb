
# HTTPアクション編集フォーム
class HttpActionEditForm < ActiveForm
  column :enable,      :type => :boolean
  column :http_method, :type => :text
  column :url,         :type => :text
  column :body,        :type => :text

  validates_presence_of :http_method
  validates_presence_of :url
  validates_length_of :url, :maximum => HttpAction::UrlMaximumLength, :allow_nil => true
  validates_length_of :body, :maximum => HttpAction::BodyMaximumLength, :allow_nil => true
  validates_inclusion_of :http_method, :in => HttpAction::HttpMethods, :allow_nil => true
  validates_format_of :url, :with => URI.regexp(["http"]), :allow_nil => true
end

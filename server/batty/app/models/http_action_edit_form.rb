
# HTTPアクション編集フォーム
class HttpActionEditForm < ActiveForm
  column :enable,      :type => :boolean
  column :http_method, :type => :text
  column :url,         :type => :text
  column :body,        :type => :text
end

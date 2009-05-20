
# メールアクション編集フォーム
class EmailActionEditForm < ActiveForm
  column :enable,  :type => :boolean
  column :email,   :type => :text
  column :subject, :type => :text
  column :body,    :type => :text
end

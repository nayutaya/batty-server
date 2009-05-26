
# メールパスワード編集フォーム
class EmailPasswordEditForm < ActiveForm
  column :password,              :type => :text
  column :password_confirmation, :type => :text
end

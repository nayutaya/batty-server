
# メールログインフォーム
class EmailLoginForm < ActiveForm
  column :email,    :type => :text
  column :password, :type => :text

  validates_presence_of :email
  validates_presence_of :password
end

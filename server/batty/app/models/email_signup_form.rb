
# メールサインアップフォーム
class EmailSignupForm < ActiveForm
  column :email,                 :type => :text
  column :password,              :type => :text
  column :password_confirmation, :type => :text

  validates_presence_of :email
  validates_presence_of :password
  validates_presence_of :password_confirmation
end

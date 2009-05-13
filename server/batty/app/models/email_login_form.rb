
# メールログインフォーム
class EmailLoginForm < ActiveForm
  column :email,    :type => :text
  column :password, :type => :text

  validates_presence_of :email
  validates_presence_of :password

  def authenticate
    return EmailCredential.authenticate(self.email, self.password)
  end
end

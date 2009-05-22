# == Schema Information
# Schema version: 20090522102421
#
# Table name: active_forms
#
#  email    :text
#  password :text
#

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

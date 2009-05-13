
# メールサインアップフォーム
class EmailSignupForm < ActiveForm
  column :email,                 :type => :text
  column :password,              :type => :text
  column :password_confirmation, :type => :text

  validates_presence_of :email
  validates_presence_of :password
  validates_presence_of :password_confirmation
  validates_length_of :email, :maximum => 200, :allow_nil => true
  validates_length_of :password, :in => 4..20, :allow_nil => true
  validates_format_of :password, :with => /\A[\x21-\x7E]+\z/
  validates_email_format_of :email
  validates_confirmation_of :password
end

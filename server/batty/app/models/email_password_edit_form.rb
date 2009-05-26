
# メールパスワード編集フォーム
class EmailPasswordEditForm < ActiveForm
  column :password,              :type => :text
  column :password_confirmation, :type => :text

  validates_presence_of :password
  validates_presence_of :password_confirmation
  validates_length_of :password, :in => EmailSignupForm::PasswordLengthRange, :allow_nil => true
  validates_format_of :password, :with => EmailSignupForm::PasswordPattern, :allow_nil => true
  validates_each(:password) { |record, attr, value|
    # MEMO: validates_confirmation_ofはpassword_confirmation属性を上書きしてしまうため、
    #       ここでは使用できない。そのため、validates_confirmation_ofを参考に独自に実装。
    confirmation = record.__send__("#{attr}_confirmation")
    if confirmation.blank? || value != confirmation
      record.errors.add(attr, :confirmation)
    end
  }

  def to_email_credential_hash
    return {
      :hashed_password => EmailCredential.create_hashed_password(self.password.to_s),
    }
  end
end

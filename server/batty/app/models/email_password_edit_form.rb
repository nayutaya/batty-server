
# メールパスワード編集フォーム
class EmailPasswordEditForm < ActiveForm
  column :password,              :type => :text
  column :password_confirmation, :type => :text

  validates_presence_of :password
  validates_presence_of :password_confirmation
  validates_length_of :password, :in => 4..20, :allow_nil => true
  validates_format_of :password, :with => /\A[\x21-\x7E]+\z/, :allow_nil => true
  validates_each(:password) { |record, attr, value|
    # MEMO: validates_confirmation_ofはpassword_confirmation属性を上書きしてしまうため、
    #       ここでは使用できない。そのため、validates_confirmation_ofを参考に独自に実装。
    confirmation = record.__send__("#{attr}_confirmation")
    if confirmation.blank? || value != confirmation
      record.errors.add(attr, :confirmation)
    end
  }
end

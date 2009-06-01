
# メールアドレス編集フォーム
class EmailAddressEditForm < ActiveForm
  column :email, :type => :text

  validates_presence_of :email
  validates_length_of :email, :maximum => 200, :allow_nil => true
  validates_email_format_of :email

  def to_email_address_hash
    return {
      :email => self.email,
    }
  end
end


# メールログインフォーム
class EmailLoginForm < ActiveForm
  column :email,    :type => :text
  column :password, :type => :text

  # TODO: emailの存在を検証
  # TODO: passwordの存在を検証
end

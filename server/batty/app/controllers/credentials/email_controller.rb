
# メールログイン情報コントローラ
class Credentials::EmailController < ApplicationController
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_email_credential_id, :only => [:edit_password]
  before_filter :specified_email_credential_belongs_to_login_user, :only => [:edit_password]

  # GET /credential/email/:email_credential_id/edit_password
  def edit_password
    # TODO: 編集用フォームを生成
  end

  # POST /credential/email/:email_credential_id/update_password
  # TODO: 実装せよ

  private

  def required_param_email_credential_id(email_credential_id = params[:email_credential_id])
    @email_credential = EmailCredential.find_by_id(email_credential_id)
    if @email_credential
      return true
    else
      set_error("メールログイン情報IDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end

  def specified_email_credential_belongs_to_login_user
    if @email_credential.user_id == @login_user.id
      return true
    else
      set_error("メールログイン情報IDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end
end

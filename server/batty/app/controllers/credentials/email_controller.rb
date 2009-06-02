
# メールログイン情報コントローラ
class Credentials::EmailController < ApplicationController
  # FIXME: 編集フォームクラスを定数化

  verify_method_post :only => [:update_password, :destroy]
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_email_credential_id
  before_filter :specified_email_credential_belongs_to_login_user

  # GET /credential/email/:email_credential_id/edit_password
  def edit_password
    @edit_form = EmailPasswordEditForm.new
  end

  # POST /credential/email/:email_credential_id/update_password
  def update_password
    @edit_form = EmailPasswordEditForm.new(params[:edit_form])

    @email_credential.attributes = @edit_form.to_email_credential_hash

    if @edit_form.valid? && @email_credential.save
      set_notice("パスワードを変更しました。")
      redirect_to(:controller => "/credentials")
    else
      @edit_form.password              = nil
      @edit_form.password_confirmation = nil
      set_error_now("入力内容を確認してください。")
      render(:action => "edit_password")
    end
  end

  # GET /credential/email/:email_credential_id/delete
  def delete
    # nop
  end

  # POST /credential/email/:email_credential_id/destroy
  def destroy
    @email_credential.destroy

    set_notice("メールログイン情報を削除しました。")
    redirect_to(:controller => "/credentials")
  end

  private

  # FIXME: login_userに属することを同時に確認
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

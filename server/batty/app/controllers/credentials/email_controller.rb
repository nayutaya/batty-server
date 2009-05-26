
# メールログイン情報コントローラ
class Credentials::EmailController < ApplicationController
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:update_password])
  before_filter :authentication, :except => [:destroy]
  before_filter :authentication_required, :except => [:destroy]
  before_filter :required_param_email_credential_id, :only => [:edit_password, :update_password, :delete]
  before_filter :specified_email_credential_belongs_to_login_user, :only => [:edit_password, :update_password, :delete]

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

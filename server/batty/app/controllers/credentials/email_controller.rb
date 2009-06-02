
# メール認証情報コントローラ
class Credentials::EmailController < ApplicationController
  EditFormClass = EmailCredentialEditForm

  verify_method_post :only => [:create, :update_password, :destroy]
  before_filter :authentication, :except => [:created, :activaton, :activate, :activated]
  before_filter :authentication_required, :except => [:created, :activaton, :activate, :activated]
  before_filter :required_param_email_credential_id, :except => [:new, :create, :created, :activaton, :activate, :activated]
  before_filter :specified_email_credential_belongs_to_login_user, :except => [:new, :create, :created, :activaton, :activate, :activated]

  # GET /credential/emails/new
  def new
    @edit_form = EditFormClass.new
  end

  # GET /credential/emails/create
  def create
    @edit_form = EditFormClass.new(params[:edit_form])

    @email_credential = @login_user.email_credentials.build
    @email_credential.attributes       = @edit_form.to_email_credential_hash
    @email_credential.activation_token = EmailCredential.create_unique_activation_token

    if @edit_form.valid? && @email_credential.save
      set_notice("メール認証情報を追加しました。")
      redirect_to(:action => "created", :email_credential_id => @email_credential.id)
    else
      @edit_form.password              = nil
      @edit_form.password_confirmation = nil
      set_error_now("入力内容を確認してください。")
      render(:action => "new")
    end
  end

  # GET /credential/email/:email_credential_id/created
  # TODO: 実装せよ

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

    set_notice("メール認証情報を削除しました。")
    redirect_to(:controller => "/credentials")
  end

  # GET /credential/email/token/:activation_token/activation
  # TODO: 実装せよ

  # POST /credential/email/token/:activation_token/activate
  # TODO: 実装せよ

  # GET /credential/email/token/:activation_token/activated
  # TODO: 実装せよ

  private

  # FIXME: login_userに属することを同時に確認
  def required_param_email_credential_id(email_credential_id = params[:email_credential_id])
    @email_credential = EmailCredential.find_by_id(email_credential_id)
    if @email_credential
      return true
    else
      set_error("メール認証情報IDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end

  def specified_email_credential_belongs_to_login_user
    if @email_credential.user_id == @login_user.id
      return true
    else
      set_error("メール認証情報IDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end
end

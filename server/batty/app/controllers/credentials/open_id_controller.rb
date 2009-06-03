
# OpenID認証情報コントローラ
class Credentials::OpenIdController < ApplicationController
  verify_method_post :only => [:destroy]
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_open_id_credential_id, :only => [:delete, :destroy]
  before_filter :specified_open_id_credential_belongs_to_login_user, :only => [:delete, :destroy]

  # GET /credentials/open_id/new
  def new
    @login_form = OpenIdLoginForm.new
  end

  # POST /credentials/open_id/create
  # GET  /credentials/open_id/create
  def create
    @login_form = OpenIdLoginForm.new(:openid_url => params[:openid_url])

    unless @login_form.valid?
      set_error_now("入力内容を確認してください。")
      render(:action => "new")
      return
    end

    begin_open_id_authentication(@login_form.openid_url) { |result, identity_url|
      if result.successful?
        p [:success, result, identity_url]
      else
        p [:failed, result, identity_url]
      end
    }
  end

  # GET /credential/open_id/:open_id_credential_id/delete
  def delete
    # nop
  end

  # POST /credential/open_id/:open_id_credential_id/destroy
  def destroy
    @open_id_credential.destroy

    set_notice("OpenID認証情報を削除しました。")
    redirect_to(:controller => "/credentials")
  end

  private

  # FIXME: login_userに属することを同時に確認
  def required_param_open_id_credential_id(open_id_credential_id = params[:open_id_credential_id])
    @open_id_credential = OpenIdCredential.find_by_id(open_id_credential_id)
    if @open_id_credential
      return true
    else
      set_error("OpenID認証情報IDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end

  def specified_open_id_credential_belongs_to_login_user
    if @open_id_credential.user_id == @login_user.id
      return true
    else
      set_error("OpenID認証情報IDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end
end

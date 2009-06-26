
# 通知先メールアドレス
class EmailsController < ApplicationController
  EditFormClass = EmailAddressEditForm

  verify_method_post :only => [:create, :destroy, :activate]
  before_filter :authentication
  before_filter :authentication_required, :except => [:activation, :activate, :activated]
  before_filter :required_param_email_address_id_for_login_user, :only => [:created, :delete, :destroy]
  before_filter :required_param_activation_token, :only => [:activation, :activate, :activated]
  before_filter :only_inactive_email_address, :only => [:activation, :activate]

  # GET /emails/new
  def new
    @edit_form = EditFormClass.new
  end

  # POST /emails/create
  def create
    @edit_form = EditFormClass.new(params[:edit_form])

    @email_address = @login_user.email_addresses.build
    @email_address.attributes = @edit_form.to_email_address_hash

    if @edit_form.valid? && @email_address.save
      # TODO: テスト
      @activation_url = url_for(
        :only_path        => false,
        :controller       => "emails",
        :action           => "activation",
        :activation_token => @email_address.activation_token)

      # TODO: テスト
      ActivationMailer.deliver_request_for_notice(
        :recipients     => @email_address.email,
        :activation_url => @activation_url)

      set_notice("メールアドレスを追加しました。")
      redirect_to(:action => "created", :email_address_id => @email_address.id)
    else
      set_error_now("入力内容を確認してください。")
      render(:action => "new")
    end
  end

  # GET /email/:email_address_id/created
  def created
    # nop
  end

  # GET /email/:email_address_id/delete
  def delete
    # nop
  end

  # POST /email/:email_address_id/destroy
  def destroy
    @email_address.destroy

    set_notice("メールアドレスを削除しました。")
    redirect_to(:controller => "settings")
  end

  # GET /email/token/:activation_token/activation
  def activation
    # nop
  end

  # POST /email/token/:activation_token/activate
  def activate
    @email_address.activate!

    # TODO: テスト
    ActivationMailer.deliver_complete_for_notice(
      :recipients => @email_address.email)

    redirect_to(:action => "activated")
  end

  # GET /email/token/:activation_token/activated
  def activated
    # nop
  end

  private

  def required_param_email_address_id_for_login_user(email_address_id = params[:email_address_id])
    @email_address = @login_user.email_addresses.find_by_id(email_address_id)
    if @email_address
      return true
    else
      set_error("メールアドレスIDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end

  def required_param_activation_token(activation_token = params[:activation_token])
    @email_address = EmailAddress.find_by_activation_token(activation_token)
    if @email_address
      return true
    else
      set_error("アクティベーショントークンが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end

  def only_inactive_email_address
    if @email_address.activated?
      set_error("既にアクティベーションされています。")
      redirect_to(root_path)
      return false
    else
      return true
    end
  end
end

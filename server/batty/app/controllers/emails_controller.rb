
# メールアドレス
class EmailsController < ApplicationController
  EditFormClass = EmailAddressEditForm

  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:create, :destroy])
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_email_address_id_for_login_user, :only => [:delete, :destroy]

  # GET /emails/new
  def new
    @edit_form = EditFormClass.new
  end

  # POST /emails/create
  def create
    @edit_form = EditFormClass.new(params[:edit_form])

    @email_address = @login_user.email_addresses.build(@edit_form.to_email_address_hash)
    @email_address.activation_token = EmailAddress.create_unique_activation_token

    if @edit_form.valid? && @email_address.save
      set_notice("メールアドレスを追加しました。")
      redirect_to(:controller => "settings", :action => "index")
    else
      set_error_now("入力内容を確認してください。")
      render(:action => "new")
    end
  end

  # GET /emails/created
  # TODO: 実装せよ

  # GET /email/token/:activation_token/activation
  # TODO: 実装せよ

  # POST /email/token/:activation_token/activate
  # TODO: 実装せよ

  # GET /email/token/:activation_token/activated
  # TODO: 実装せよ

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
end

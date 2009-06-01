
# メールアドレス
class EmailsController < ApplicationController
  EditFormClass = EmailAddressEditForm

  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:create])
  before_filter :authentication
  before_filter :authentication_required

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
end

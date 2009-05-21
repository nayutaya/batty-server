
# メールアクション
class EmailActionsController < ApplicationController
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_device_token
  before_filter :required_param_trigger_id

  # GET /device/:device_token/trigger/:trigger_id/acts/email/new
  def new
    @edit_form = EmailActionEditForm.new
  end

  # POST /device/:device_token/trigger/:trigger_id/acts/email/create
  def create
    @edit_form = EmailActionEditForm.new(params[:edit_form])

    if @edit_form.valid?
      @action = EmailAction.new(@edit_form.to_email_action_hash)
      @action.trigger_id = @trigger.id
      @action.save!

      set_notice("アクションを追加しました。")
      redirect_to(:controller => "devices", :action => "show", :device_token => @device.device_token)
    else
      set_error_now("入力内容を確認してください。")
      render(:action => "new")
    end
  end
end

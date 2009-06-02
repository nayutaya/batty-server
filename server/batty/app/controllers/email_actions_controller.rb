
# メールアクション
class EmailActionsController < ApplicationController
  EditFormClass = EmailActionEditForm

  verify_method_post :only => [:create, :update, :destroy]
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_device_id
  before_filter :required_param_trigger_id
  before_filter :required_param_email_action_id, :only => [:edit, :update, :delete, :destroy]
  before_filter :specified_device_belongs_to_login_user
  before_filter :specified_trigger_belongs_to_device
  before_filter :specified_email_action_belongs_to_trigger, :only => [:edit, :update, :delete, :destroy]

  # GET /device/:device_id/trigger/:trigger_id/acts/email/new
  def new
    @edit_form = EditFormClass.new
  end

  # POST /device/:device_id/trigger/:trigger_id/acts/email/create
  def create
    @edit_form = EditFormClass.new(params[:edit_form])

    # FIXME: EmailActionモデルも検証
    if @edit_form.valid?
      # FIXME: @trigger.email_actions.buildを使う
      @action = EmailAction.new(@edit_form.to_email_action_hash)
      @action.trigger_id = @trigger.id
      @action.save!

      set_notice("アクションを追加しました。")
      redirect_to(device_path(:device_id => @device.id))
    else
      set_error_now("入力内容を確認してください。")
      render(:action => "new")
    end
  end

  # GET /device/:device_id/trigger/:trigger_id/act/email/:email_action_id/edit
  def edit
    @edit_form = EditFormClass.new(
      :enable  => @email_action.enable,
      :email   => @email_action.email,
      :subject => @email_action.subject,
      :body    => @email_action.body)
  end

  # POST /device/:device_id/trigger/:trigger_id/act/email/:email_action_id/update
  def update
    @edit_form = EditFormClass.new(params[:edit_form])

    # FIXME: EmailActionモデルも検証
    if @edit_form.valid?
      @email_action.attributes = @edit_form.to_email_action_hash
      @email_action.save!

      set_notice("メール通知を更新しました。")
      redirect_to(device_path(:device_id => @device.id))
    else
      set_error_now("入力内容を確認してください。")
      render(:action => "edit")
    end
  end

  # GET /device/:device_id/trigger/:trigger_id/act/email/:email_action_id/delete
  def delete
    # nop
  end

  # POST /device/:device_id/trigger/:trigger_id/act/email/:email_action_id/destroy
  def destroy
    @email_action.destroy

    set_notice("メール通知を削除しました。")
    redirect_to(device_path(:device_id => @device.id))
  end

  private

  # FIXME: login_userに属することも同時に検証
  def required_param_email_action_id(email_action_id = params[:email_action_id])
    @email_action = EmailAction.find_by_id(email_action_id)
    if @email_action
      return true
    else
      set_error("メール通知IDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end

  def specified_email_action_belongs_to_trigger
    if @email_action.trigger_id == @trigger.id
      return true
    else
      set_error("メール通知IDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end
end

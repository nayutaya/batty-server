
# HTTPアクション
class HttpActionsController < ApplicationController
  EditFormClass = HttpActionEditForm

  verify_method_post :only => [:create, :update, :destroy]
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_device_id
  before_filter :required_param_trigger_id
  before_filter :required_param_http_action_id, :only => [:edit, :update, :delete, :destroy]
  before_filter :specified_device_belongs_to_login_user
  before_filter :specified_trigger_belongs_to_device
  before_filter :specified_http_action_belongs_to_trigger, :only => [:edit, :update, :delete, :destroy]

  # GET /device/:device_id/trigger/:trigger_id/acts/http/new
  def new
    @edit_form = EditFormClass.new(:enable => true)
    set_http_methods_for_select(true)
  end

  # POST /device/:device_id/trigger/:trigger_id/acts/http/create
  def create
    @edit_form = EditFormClass.new(params[:edit_form])

    @action = @trigger.http_actions.build
    @action.attributes = @edit_form.to_http_action_hash

    if @edit_form.valid? && @action.save
      set_notice("アクションを追加しました。")
      redirect_to(device_path(:device_id => @device.id))
    else
      set_http_methods_for_select(true)
      set_error_now("入力内容を確認してください。")
      render(:action => "new")
    end
  end

  # GET /device/:device_id/trigger/:trigger_id/act/http/:http_action_id/edit
  def edit
    @edit_form = EditFormClass.new(
      :enable      => @http_action.enable,
      :http_method => @http_action.http_method,
      :url         => @http_action.url,
      :body        => @http_action.body)
    set_http_methods_for_select(false)
  end

  # POST /device/:device_id/trigger/:trigger_id/act/http/:http_action_id/update
  def update
    @edit_form = EditFormClass.new(params[:edit_form])

    @http_action.attributes = @edit_form.attributes

    if @edit_form.valid? && @http_action.save
      set_notice("Web Hookを更新しました。")
      redirect_to(device_path(:device_id => @device.id))
    else
      set_http_methods_for_select(false)
      set_error_now("入力内容を確認してください。")
      render(:action => "edit")
    end
  end

  # GET /device/:device_id/trigger/:trigger_id/act/http/:http_action_id/delete
  def delete
    # nop
  end

  # POST /device/:device_id/trigger/:trigger_id/act/http/:http_action_id/destroy
  def destroy
    @http_action.destroy

    set_notice("Web Hookを削除しました。")
    redirect_to(device_path(:device_id => @device.id))
  end

  private

  # FIXME: triggerに属することを検証
  def required_param_http_action_id(http_action_id = params[:http_action_id])
    @http_action = HttpAction.find_by_id(http_action_id)
    if @http_action
      return true
    else
      set_error("Web Hook IDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end

  def specified_http_action_belongs_to_trigger
    if @http_action.trigger_id == @trigger.id
      return true
    else
      set_error("Web Hook IDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end

  def set_http_methods_for_select(include_blank)
    @http_methods_for_select = HttpActionEditForm.http_methods_for_select(
      :include_blank => include_blank)
  end
end

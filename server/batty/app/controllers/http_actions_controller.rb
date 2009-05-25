
# HTTPアクション
# FIXME: EditFormClass = HttpActionEditForm
class HttpActionsController < ApplicationController
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:create])
  before_filter :authentication, :except => [:update, :delete, :destroy]
  before_filter :authentication_required, :except => [:update, :delete, :destroy]
  before_filter :required_param_device_id, :except => [:update, :delete, :destroy]
  before_filter :required_param_trigger_id, :except => [:update, :delete, :destroy]
  before_filter :required_param_http_action_id, :only => [:edit]
  before_filter :specified_device_belongs_to_login_user, :except => [:update, :delete, :destroy]
  before_filter :specified_trigger_belongs_to_device, :except => [:update, :delete, :destroy]
  before_filter :specified_http_action_belongs_to_trigger, :only => [:edit]

  # GET /device/:device_id/trigger/:trigger_id/acts/http/new
  def new
    @edit_form = HttpActionEditForm.new
    set_http_methods_for_select(true)
  end

  # POST /device/:device_id/trigger/:trigger_id/acts/http/create
  def create
    @edit_form = HttpActionEditForm.new(params[:edit_form])

    if @edit_form.valid?
      @action = HttpAction.new(@edit_form.to_http_action_hash)
      @action.trigger_id = @trigger.id
      @action.save!

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
    @edit_form = HttpActionEditForm.new(
      :enable      => @http_action.enable,
      :http_method => @http_action.http_method,
      :url         => @http_action.url)
    set_http_methods_for_select(false)
  end

  # POST /device/:device_id/trigger/:trigger_id/act/http/:http_action_id/update

  # GET /device/:device_id/trigger/:trigger_id/act/http/:http_action_id/delete

  # POST /device/:device_id/trigger/:trigger_id/act/http/:http_action_id/destroy

  private

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

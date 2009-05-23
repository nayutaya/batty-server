
# HTTPアクション
class HttpActionsController < ApplicationController
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:create])
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_device_id
  before_filter :required_param_trigger_id
  before_filter :specified_device_belongs_to_login_user

  # GET /device/:device_id/trigger/:trigger_id/acts/http/new
  def new
    @edit_form = HttpActionEditForm.new
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
      set_error_now("入力内容を確認してください。")
      render(:action => "new")
    end
  end
end

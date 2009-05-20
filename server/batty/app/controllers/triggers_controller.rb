
# トリガ
class TriggersController < ApplicationController
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:create])

  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_device_token
  before_filter :required_param_trigger_id, :only => [:show]

  # GET /device/:device_token/triggers/new
  def new
    @edit_form = TriggerEditForm.new
    set_operators_for_select
  end

  # POST /device/:device_token/triggers/create
  def create
    @edit_form = TriggerEditForm.new(params[:edit_form])

    if @edit_form.valid?
      @trigger = Trigger.new(@edit_form.to_trigger_hash)
      @trigger.device_id = @device.id
      @trigger.save!

      set_notice("トリガを追加しました。")
      redirect_to(:controller => "devices", :action => "show", :device_token => @device.device_token)
    else
      set_operators_for_select
      set_error_now("入力内容を確認してください。")
      render(:action => "new")
    end
  end

  # GET /device/:device_token/trigger/:trigger_id
  def show
    # nop
  end

  private

  def required_param_trigger_id(trigger_id = params[:trigger_id])
    @trigger = Trigger.find_by_id(trigger_id)
    if @trigger
      return true
    else
      set_error("トリガIDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end

  def set_operators_for_select
    @operators_for_select = TriggerEditForm.operators_for_select(
      :include_blank => true)
  end
end

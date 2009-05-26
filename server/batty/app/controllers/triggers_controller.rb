
# トリガ
class TriggersController < ApplicationController
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:create])
  before_filter :authentication, :except => [:update, :delete, :destroy]
  before_filter :authentication_required, :except => [:update, :delete, :destroy]
  before_filter :required_param_device_id, :except => [:update, :delete, :destroy]
  before_filter :required_param_trigger_id, :only => [:edit]
  before_filter :specified_device_belongs_to_login_user, :except => [:update, :delete, :destroy]
  before_filter :specified_trigger_belongs_to_device, :only => [:edit]

  # GET /device/:device_id/triggers/new
  def new
    @edit_form = TriggerEditForm.new
    set_operators_for_select(true)
  end

  # POST /device/:device_id/triggers/create
  def create
    @edit_form = TriggerEditForm.new(params[:edit_form])

    if @edit_form.valid?
      @trigger = Trigger.new(@edit_form.to_trigger_hash)
      @trigger.device_id = @device.id
      @trigger.save!

      set_notice("トリガを追加しました。")
      redirect_to(device_path(:device_id => @device.id))
    else
      set_operators_for_select(true)
      set_error_now("入力内容を確認してください。")
      render(:action => "new")
    end
  end

  # GET /device/:device_id/trigger/:trigger_id/edit
  def edit
    @edit_form = TriggerEditForm.new(
      :enable   => @trigger.enable,
      :operator => @trigger.operator,
      :level    => @trigger.level)
    set_operators_for_select(false)
  end

  # POST /device/:device_id/trigger/:trigger_id/update
  # TODO: 実装せよ

  # GET /device/:device_id/trigger/:trigger_id/delete
  # TODO: 実装せよ

  # POST /device/:device_id/trigger/:trigger_id/destroy
  # TODO: 実装せよ

  private

  def set_operators_for_select(include_blank)
    @operators_for_select = TriggerEditForm.operators_for_select(
      :include_blank => include_blank)
  end
end

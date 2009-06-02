
# トリガ
class TriggersController < ApplicationController
  EditFormClass = TriggerEditForm

  verify_method_post :only => [:create, :update, :destroy]
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_device_id
  before_filter :required_param_trigger_id, :only => [:edit, :update, :delete, :destroy]
  before_filter :specified_device_belongs_to_login_user
  before_filter :specified_trigger_belongs_to_device, :only => [:edit, :update, :delete, :destroy]

  # GET /device/:device_id/triggers/new
  def new
    @edit_form = EditFormClass.new
    set_operators_for_select(true)
  end

  # POST /device/:device_id/triggers/create
  def create
    @edit_form = EditFormClass.new(params[:edit_form])

    # FIXME: Triggerモデルも検証
    if @edit_form.valid?
      # FIXME: @device.triggers.buildを使う
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
    @edit_form = EditFormClass.new(
      :enable   => @trigger.enable,
      :operator => @trigger.operator,
      :level    => @trigger.level)
    set_operators_for_select(false)
  end

  # POST /device/:device_id/trigger/:trigger_id/update
  def update
    @edit_form = EditFormClass.new(params[:edit_form])

    # FIXME: Triggerモデルも検証
    if @edit_form.valid?
      @trigger.attributes = @edit_form.to_trigger_hash
      @trigger.save!

      set_notice("トリガを更新しました。")
      redirect_to(device_path(:device_id => @device.id))
    else
      set_operators_for_select(false)
      set_error_now("入力内容を確認してください。")
      render(:action => "edit")
    end
  end

  # GET /device/:device_id/trigger/:trigger_id/delete
  def delete
    # nop
  end

  # POST /device/:device_id/trigger/:trigger_id/destroy
  def destroy
    @trigger.destroy

    set_notice("トリガを削除しました。")
    redirect_to(device_path(:device_id => @device.id))
  end

  private

  def set_operators_for_select(include_blank)
    @operators_for_select = EditFormClass.operators_for_select(
      :include_blank => include_blank)
  end
end

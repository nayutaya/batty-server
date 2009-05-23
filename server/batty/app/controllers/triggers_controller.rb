
# トリガ
class TriggersController < ApplicationController
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:create])
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_device_id

  # GET /device/:device_id/triggers/new
  def new
    @edit_form = TriggerEditForm.new
    set_operators_for_select
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
      set_operators_for_select
      set_error_now("入力内容を確認してください。")
      render(:action => "new")
    end
  end

  private

  def set_operators_for_select
    @operators_for_select = TriggerEditForm.operators_for_select(
      :include_blank => true)
  end
end


# トリガ
class TriggersController < ApplicationController
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_device_token

  # GET /device/:device_token/triggers/new
  def new
    @edit_form = TriggerEditForm.new
    set_operators_for_select
  end

  private

  def set_operators_for_select
    @operators_for_select = TriggerEditForm.operators_for_select(
      :include_blank => true)
  end
end

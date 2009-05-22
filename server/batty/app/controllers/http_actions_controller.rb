
# HTTPアクション
class HttpActionsController < ApplicationController
  before_filter :authentication, :except => [:create]
  before_filter :authentication_required, :except => [:create]
  before_filter :required_param_device_id, :except => [:create]
  before_filter :required_param_trigger_id, :except => [:create]

  # GET /device/:device_id/trigger/:trigger_id/acts/http/new
  def new
    @edit_form = HttpActionEditForm.new
  end

  # POST /device/:device_id/trigger/:trigger_id/acts/http/create
  # TODO: 実装せよ
end

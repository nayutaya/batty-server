
# トリガ
class TriggersController < ApplicationController
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_device_token

  # GET /device/:device_token/triggers/new
  def new
    # nop
  end
end

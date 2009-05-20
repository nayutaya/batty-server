
# メールアクション
class EmailActionsController < ApplicationController
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_device_token
  before_filter :required_param_trigger_id

  # GET /device/:device_token/trigger/:trigger_id/acts/email/new
  def new
    # nop
  end
end

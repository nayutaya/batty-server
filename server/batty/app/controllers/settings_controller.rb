
# ユーザ設定
class SettingsController < ApplicationController
  verify(
    :xhr    => true,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:get_nickname])
  before_filter :authentication, :except => [:set_nickname]
  before_filter :authentication_required, :except => [:set_nickname]

  # GET /settings
  def index
    # nop
  end

  # XHR GET /settings/get_nickname
  def get_nickname
    render(:text => @login_user.nickname)
  end

  # ?
  def set_nickname
    render(:text => "")
    return
    @login_user.nickname = params[:value]
    if @login_user.save
      render(:text => ERB::Util.h(@login_user.nickname))
    else
      message = @login_user.errors.on(:nickname)
      message = message.join(", ") if message.kind_of?(Array)
      render(:text => ERB::Util.h(message), :status => 400)
    end
  end
end

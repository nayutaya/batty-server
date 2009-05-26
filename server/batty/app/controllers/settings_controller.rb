
# ユーザ設定
class SettingsController < ApplicationController
  verify(
    :xhr    => true,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:get_nickname, :set_nickname])
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:set_nickname])
  before_filter :authentication
  before_filter :authentication_required

  # GET /settings
  def index
    # nop
  end

  # XHR GET /settings/get_nickname
  # MEMO: HTMLエスケープは不要
  def get_nickname
    render(:text => @login_user.nickname)
  end

  # XHR POST /settings/set_nickname
  # MEMO: HTMLエスケープが必要
  def set_nickname
    @login_user.nickname = params[:value]

    if @login_user.save
      render(:text => ERB::Util.h(@login_user.nickname))
    else
      message = @login_user.errors.on(:nickname).to_s
      render(:text => ERB::Util.h(message), :status => 422)
    end
  end
end

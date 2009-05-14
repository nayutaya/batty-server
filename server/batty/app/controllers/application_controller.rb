
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  GetText.locale = "ja"
  init_gettext "batty"

  private

  def set_error(message)
    flash[:notice] = @flash_notice = nil
    flash[:error]  = @flash_error  = message
  end

  def set_error_now(message)
    flash.now[:notice] = @flash_notice = nil
    flash.now[:error]  = @flash_error  = message
  end

  def send_rss(rss)
    send_data(rss.to_s, :type => "application/rss+xml", :disposition => "inline")
  end
end

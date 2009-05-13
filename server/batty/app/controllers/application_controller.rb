
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  GetText.locale = "ja"
  init_gettext "batty"

  private

  def send_rss(rss)
    send_data(rss.to_s, :type => "application/rss+xml", :disposition => "inline")
  end
end

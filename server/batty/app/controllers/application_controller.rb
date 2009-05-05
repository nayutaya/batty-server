
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  private

  def send_rss(rss)
    send_data(rss.to_s, :type => "application/rss+xml", :disposition => "inline")
  end
end

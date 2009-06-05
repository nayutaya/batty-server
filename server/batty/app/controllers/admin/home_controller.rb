
require "ipaddr"

# 管理用ホーム
class Admin::HomeController < ApplicationController
  layout "admin"
  before_filter :access_control

  AllowedNetworks = [
    IPAddr.new("0.0.0.0/32"),
    IPAddr.new("127.0.0.1/32"),
  ].freeze

  # GET /admin
  def index
    # nop
  end

  private

  def access_control
    remote_addr = IPAddr.new(request.remote_ip)
    if AllowedNetworks.any? { |network| network.include?(remote_addr) }
      return true
    else
      redirect_to(root_path)
      return false
    end
  end
end

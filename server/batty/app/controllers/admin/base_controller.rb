
require "ipaddr"

# 管理用ベース
class Admin::BaseController < ApplicationController
  AllowedNetworks = [
    IPAddr.new("0.0.0.0/32"),
    IPAddr.new("127.0.0.1/32"),
  ].freeze

  layout "admin"
  before_filter :access_control

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

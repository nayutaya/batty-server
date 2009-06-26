# == Schema Information
# Schema version: 20090529051529
#
# Table name: active_forms
#
#  openid_url :text
#

# OpenIDログインフォーム
class OpenIdLoginForm < ActiveForm
  column :openid_url, :type => :text

  N_("OpenIdLoginForm|Openid url")

  validates_presence_of :openid_url
  validates_length_of :openid_url, :maximum => 200, :allow_nil => true
end

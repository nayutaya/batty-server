# -*- coding: utf-8 -*-

# == Schema Information
# Schema version: 20090420021540
#
# Table name: devices
#
#  id             :integer       not null, primary key
#  created_at     :datetime      not null
#  updated_at     :datetime      not null
#  device_token   :string(40)    not null, index_devices_on_device_token(unique)
#  user_id        :integer       not null, index_devices_on_user_id
#  name           :string(50)    not null, index_devices_on_name
#  device_icon_id :integer       not null, index_devices_on_device_icon_id
#

# デバイス
class Device < ActiveRecord::Base
  has_many :energies
  has_many :triggers
  has_many :events
  belongs_to :user
  belongs_to :device_icon

  validates_presence_of :name
  validates_length_of :name, :maximum => 50
  validates_presence_of :device_token
  validates_format_of :device_token, :with => TokenUtil.create_token_regexp(20)
  validates_uniqueness_of :device_token

  def self.create_unique_device_token
    TokenUtil.create_unique_token(self, :device_token, 20)
  end

  def current_energy
    energies.first(:order => "observed_at DESC")
  end
end

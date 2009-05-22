# == Schema Information
# Schema version: 20090522102421
#
# Table name: device_icons
#
#  id            :integer       not null, primary key
#  created_at    :datetime      not null
#  updated_at    :datetime      not null
#  display_order :integer       not null, index_device_icons_on_display_order
#  name          :string(30)    not null
#  url24         :string(200)   not null
#  url48         :string(200)   not null
#

# デバイスアイコン
class DeviceIcon < ActiveRecord::Base
  has_many :devices

  validates_presence_of :display_order
  validates_presence_of :name
  validates_presence_of :url24
  validates_presence_of :url48
  validates_length_of :name, :maximum => 30, :allow_nil => true
  validates_length_of :url24, :maximum => 200, :allow_nil => true
  validates_length_of :url48, :maximum => 200, :allow_nil => true
end

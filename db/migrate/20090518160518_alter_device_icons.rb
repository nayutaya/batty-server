
class AlterDeviceIcons < ActiveRecord::Migration
  def self.up
    rename_column(:device_icons, :url16, :url24)
    rename_column(:device_icons, :url32, :url48)
  end

  def self.down
    rename_column(:device_icons, :url24, :url16)
    rename_column(:device_icons, :url48, :url32)
  end
end

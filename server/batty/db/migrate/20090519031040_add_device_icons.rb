
class AddDeviceIcons < ActiveRecord::Migration
  def self.up
    DeviceIcon.create!(
      :display_order => 1,
      :name          => "スマートフォン",
      :url24         => "/images/icons/devices/smartphone24.png",
      :url48         => "/images/icons/devices/smartphone48.png")

    DeviceIcon.create!(
      :display_order => 2,
      :name          => "PDA",
      :url24         => "/images/icons/devices/pda24.png",
      :url48         => "/images/icons/devices/pda48.png")

    DeviceIcon.create!(
      :display_order => 3,
      :name          => "携帯電話",
      :url24         => "/images/icons/devices/cellular24.png",
      :url48         => "/images/icons/devices/cellular48.png")

    DeviceIcon.create!(
      :display_order => 4,
      :name          => "ノートパソコン",
      :url24         => "/images/icons/devices/note24.png",
      :url48         => "/images/icons/devices/note48.png")

    DeviceIcon.create!(
      :display_order => 5,
      :name          => "MacBook (白)",
      :url24         => "/images/icons/devices/macbook-white24.png",
      :url48         => "/images/icons/devices/macbook-white48.png")

    DeviceIcon.create!(
      :display_order => 6,
      :name          => "MacBook (黒)",
      :url24         => "/images/icons/devices/macbook-black24.png",
      :url48         => "/images/icons/devices/macbook-black48.png")

    DeviceIcon.create!(
      :display_order => 7,
      :name          => "MacBook Pro",
      :url24         => "/images/icons/devices/macbook-pro24.png",
      :url48         => "/images/icons/devices/macbook-pro48.png")

    DeviceIcon.create!(
      :display_order => 8,
      :name          => "MacBook Air",
      :url24         => "/images/icons/devices/macbook-air24.png",
      :url48         => "/images/icons/devices/macbook-air48.png")
  end

  def self.down
    DeviceIcon.delete_all
  end
end

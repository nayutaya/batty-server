
module DevicesHelper
  def device_icon24(device_icon)
    return image_tag(
      device_icon.url24,
      :width  => 24,
      :height => 24,
      :alt    => device_icon.name,
      :title  => device_icon.name)
  end

  def device_icon48(device_icon)
    return image_tag(
      device_icon.url48,
      :width  => 48,
      :height => 48,
      :alt    => device_icon.name,
      :title  => device_icon.name)
  end
end

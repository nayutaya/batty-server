
module DevicesHelper
  def device_name_link(device)
    return link_to(h(device.name), :controller => "devices", :action => "show", :device_id => device.id)
  end

  def device_icon24(device_icon, options = {})
    options = options.dup
    name = options.delete(:name) || device_icon.name
    raise(ArgumentError) unless options.empty?

    return image_tag(
      device_icon.url24,
      :width  => 24,
      :height => 24,
      :alt    => name,
      :title  => name)
  end

  def device_icon48(device_icon, options = {})
    options = options.dup
    name = options.delete(:name) || device_icon.name
    raise(ArgumentError) unless options.empty?

    return image_tag(
      device_icon.url48,
      :width  => 48,
      :height => 48,
      :alt    => name,
      :title  => name)
  end
end

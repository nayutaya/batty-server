
module DevicesHelper
  def device_name_link(device)
    return link_to(h(device.name), :controller => "devices", :action => "show", :device_id => device.id)
  end

  def device_icon24_link(device)
    return link_to(device_icon24(device.device_icon, :name => device.name), :controller => "devices", :action => "show", :device_id => device.id)
  end

  def device_icon48_link(device)
    return link_to(device_icon48(device.device_icon, :name => device.name), :controller => "devices", :action => "show", :device_id => device.id)
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

  def energy_meter(level)
    klass =
      case [[level, 0].max, 100].min
      when  0...15 then "empty"
      when 15...30 then "low"
      when 30...45 then "middle"
      when 45..100 then "high"
      else raise(ArgumentError)
      end
    width = [[level, 1].max, 100].min
    html  = %|<div class="battery-cell">|
    html += %|<div class="battery-level">|
    html += %|<div class="battery-#{klass}" style="width: #{width}px;">|
    html += %|</div></div></div>|
    return html
  end
end

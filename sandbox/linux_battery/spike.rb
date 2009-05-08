# -*- coding: utf-8 -*-
require 'socket'

def main
  # socket のパスは環境によると思う
  UNIXSocket.open('/var/run/acpid.socket') do |socket|
    event = ''
    loop do
      event << socket.recvfrom(1)[0]
      if /\n/ =~ event
        batty(event.chomp)
        event = ''
        sleep 1 # busy loop 回避
      end
    end
  end
end

#  $ acpi
#  Battery 0: Charging, 75%, 02:20:57 until charged
#  Battery 0: Unknown, 80%
#  Battery 0: Discharging, 80%, discharging at zero rate - will never fully discharge.
def batty(event)
  return unless /\Abattery/ =~ event
  info = %x!acpi -ab!
  battery, adapder = info.aplit("\n")
  # /on-line/ =~ adapter
  state, level, memo = battery.split(',')
end

Signal.trap('INT'){
  $stderr.puts "\nexit"
  exit 0
}

$stderr.sync = true
main

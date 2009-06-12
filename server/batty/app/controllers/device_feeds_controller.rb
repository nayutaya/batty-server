
require "rss"

# デバイスフィード
class DeviceFeedsController < ApplicationController
  before_filter :required_param_device_token

  # GET /device/token/:device_token/energies.rss
  def energies_rss
    @energies = @device.energies.paginate(
      :order    => "energies.observed_at DESC, energies.id DESC",
      :page     => 1,
      :per_page => 10)

    rss = RSS::Maker.make("2.0") { |maker|
      maker.channel.title       = "batty::デバイス::#{@device.name}::エネルギー"
      maker.channel.description = "#{@device.name}のエネルギー履歴"
      maker.channel.link        = url_for(:controller => "devices", :action => "energies", :device_id => @device.id)
      # FIXME: デバイスアイコンを出力

      @energies.each { |energy|
        item = maker.items.new_item
        item.link  = url_for(:controller => "devices", :action => "energies", :device_id => @device.id, :anchor => energy.observed_at.strftime("%Y%m%d%H%M%S"))
        item.title = "#{energy.observed_level}%"
        item.date  = energy.observed_at
      }
    }

    send_rss(rss)
  end

  # GET /device/token/:device_token/energies.csv
  def energies_csv
    @energies = @device.energies.all(
      :order => "energies.observed_at DESC, energies.id DESC")

    csv = ""
    @energies.each { |energy|
      line = ""
      line << energy.observed_at.strftime("%Y/%m/%d %H:%M:%S")
      line << ","
      line << energy.observed_level.to_s
      line << "\r\n"
      csv << line
    }

    send_csv(csv)
  end

  # GET /device/token/:device_token/events.rss
  def events_rss
    @events = @device.events.paginate(
      :order    => "events.observed_at DESC, events.id DESC",
      :page     => 1,
      :per_page => 10)

    rss = RSS::Maker.make("2.0") { |maker|
      maker.channel.title       = "batty::デバイス::#{@device.name}::イベント"
      maker.channel.description = "#{@device.name}のイベント履歴"
      maker.channel.link        = url_for(:controller => "devices", :action => "events", :device_id => @device.id)
      # FIXME: デバイスアイコンを出力

      @events.each { |event|
        item = maker.items.new_item
        item.link  = url_for(:controller => "devices", :action => "events", :device_id => @device.id, :anchor => event.observed_at.strftime("%Y%m%d%H%M%S"))
        item.title = "#{event.observed_level}% #{event.trigger_operator_sign} #{event.trigger_level}%"
        item.date  = event.observed_at
      }
    }

    send_rss(rss)
  end

  # GET /device/token/:device_token/events.csv
  def events_csv
    @events = @device.events.all(
      :order => "events.observed_at DESC, events.id DESC")

    csv = ""
    @events.each { |event|
      line = ""
      line << event.observed_at.strftime("%Y/%m/%d %H:%M:%S")
      line << ","
      line << event.observed_level.to_s
      line << ","
      line << event.trigger_operator_symbol.to_s
      line << ","
      line << event.trigger_level.to_s
      line << "\r\n"
      csv << line
    }

    send_csv(csv)
  end

  private

  def required_param_device_token(device_token = params[:device_token])
    return super(device_token) {
      render(:text => "Not Found", :status => 404)
    }
  end
end

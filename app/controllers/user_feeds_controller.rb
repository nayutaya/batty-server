
require "rss"

# ユーザフィード
class UserFeedsController < ApplicationController
  before_filter :required_param_user_token

  # GET /user/token/:user_token/energies.rss
  def energies_rss
    @energies = @user.energies.paginate(
      :include  => [:device],
      :order    => "energies.observed_at DESC, energies.id DESC",
      :page     => 1,
      :per_page => 10)

    rss = RSS::Maker.make("2.0") { |maker|
      maker.channel.title       = "batty::ユーザ::#{@user.nickname}::エネルギー"
      maker.channel.description = "#{@user.nickname}のエネルギー履歴"
      maker.channel.link        = url_for(:controller => "energies", :action => "index")
      # FIXME: デバイスアイコンを出力

      @energies.each { |energy|
        item = maker.items.new_item
        item.link  = url_for(:controller => "devices", :action => "energies", :device_id => energy.device_id, :anchor => energy.observed_at.strftime("%Y%m%d%H%M%S"))
        item.title = "#{energy.device.name} #{energy.observed_level}%"
        item.date  = energy.observed_at
      }
    }

    send_rss(rss)
  end

  # GET /user/token/:user_token/energies.csv
  def energies_csv
    @energies = @user.energies.all(
      :include => [:device],
      :order   => "energies.observed_at DESC, energies.id DESC")

    csv = ""
    @energies.each { |energy|
      line = ""
      line << energy.observed_at.strftime("%Y/%m/%d %H:%M:%S")
      line << ","
      line << format('"%s"', energy.device.name)
      line << ","
      line << energy.observed_level.to_s
      line << "\r\n"
      csv << line
    }

    send_csv(csv)
  end

  # GET /user/token/:user_token/events.rss
  def events_rss
    @events = @user.events.paginate(
      :include  => [:device],
      :order    => "events.observed_at DESC, events.id DESC",
      :page     => 1,
      :per_page => 10)

    rss = RSS::Maker.make("2.0") { |maker|
      maker.channel.title       = "batty::デバイス::#{@user.nickname}::イベント"
      maker.channel.description = "#{@user.nickname}のイベント履歴"
      maker.channel.link        = url_for(:controller => "events", :action => "index")
      # FIXME: デバイスアイコンを出力

      @events.each { |event|
        item = maker.items.new_item
        item.link  = url_for(:controller => "devices", :action => "events", :device_id => event.device_id, :anchor => event.observed_at.strftime("%Y%m%d%H%M%S"))
        item.title = "#{event.device.name} #{event.observed_level}% #{event.trigger_operator_sign} #{event.trigger_level}%"
        item.date  = event.observed_at
      }
    }

    send_rss(rss)
  end

  # GET /user/token/:user_token/events.csv
  def events_csv
    @events = @user.events.all(
      :include => [:device],
      :order   => "events.observed_at DESC, events.id DESC")

    csv = ""
    @events.each { |event|
      line = ""
      line << event.observed_at.strftime("%Y/%m/%d %H:%M:%S")
      line << ","
      line << format('"%s"', event.device.name)
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

  def required_param_user_token(user_token = params[:user_token])
    @user = User.find_by_user_token(user_token)
    return true if @user

    render(:text => "Not Found", :status => 404)

    return false
  end
end

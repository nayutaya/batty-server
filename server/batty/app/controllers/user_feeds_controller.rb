
require "rss"

# ユーザフィード
class UserFeedsController < ApplicationController
  before_filter :required_param_user_token

  # GET /user/token/:user_token/energies.rdf
  def energies
    @energies = @user.energies.paginate(
      :order    => "energies.observed_at DESC, energies.id DESC",
      :page     => 1,
      :per_page => 10)

    rss = RSS::Maker.make("2.0") { |maker|
      maker.channel.title       = "batty::ユーザ::#{@user.nickname}::エネルギー"
      maker.channel.description = "#{@user.nickname}のエネルギー履歴"
      maker.channel.link        = root_url # FIXME: URLを変更
      # FIXME: デバイスアイコンを出力

      @energies.each { |energy|
        item = maker.items.new_item
        item.link  = "http://batty.nayutaya.jp/user/#{@user.user_token}/" # FIXME: デバイスページのURLに変更
        item.title = "#{energy.device.name} #{energy.observed_level}%"
        item.date  = energy.observed_at
      }
    }

    send_rss(rss)
  end

  # GET /user/token/:user_token/energies.csv
  def energies_csv
    @energies = @user.energies.all(
      :order => "energies.observed_at DESC, energies.id DESC")

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

  # GET /user/token/:user_token/events.rdf
  def events
    @events = @user.events.paginate(
      :order    => "events.observed_at DESC, events.id DESC",
      :page     => 1,
      :per_page => 10)

    rss = RSS::Maker.make("2.0") { |maker|
      maker.channel.title       = "batty::デバイス::#{@user.nickname}::イベント"
      maker.channel.description = "#{@user.nickname}のイベント履歴"
      maker.channel.link        = root_url # FIXME: URLを変更
      # FIXME: デバイスアイコンを出力

      @events.each { |event|
        item = maker.items.new_item
        item.link  = "http://batty.nayutaya.jp/user/#{@user.user_token}/" # FIXME: デバイスページのURLに変更
        item.title = "#{event.device.name} #{event.observed_level}% #{event.trigger_operator_sign} #{event.trigger_level}%"
        item.date  = event.observed_at
      }
    }

    send_rss(rss)
  end

  private

  def required_param_user_token(user_token = params[:user_token])
    @user = User.find_by_user_token(user_token)
    return true if @user

    render(:text => "Not Found", :status => 404)

    return false
  end
end

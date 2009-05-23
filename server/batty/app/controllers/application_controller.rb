
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  GetText.locale = "ja"
  init_gettext "batty"

  private

  def authentication(user_id = session[:user_id])
    @login_user = User.find_by_id(user_id)
    return true
  end

  def authentication_required
    return true if @login_user

    set_error("ログインが必要です。")
    redirect_to(root_path)

    return false
  end

  def required_param_device_token(device_token = params[:device_token])
    @device = Device.find_by_device_token(device_token)
    return true if @device

    if block_given?
      yield
    else
      set_error("デバイストークンが正しくありません。")
      redirect_to(root_path)
    end

    return false
  end

  def required_param_device_id(device_id = params[:device_id])
    @device = Device.find_by_id(device_id)
    return true if @device

    set_error("デバイスIDが正しくありません。")
    redirect_to(root_path)

    return false
  end

  def required_param_trigger_id(trigger_id = params[:trigger_id])
    @trigger = Trigger.find_by_id(trigger_id)
    if @trigger
      return true
    else
      set_error("トリガIDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end

  def specified_device_belongs_to_login_user
    if @device.user_id == @login_user.id
      return true
    else
      set_error("デバイスIDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end

  def specified_trigger_belongs_to_device
    if @trigger.device_id == @device.id
      return true
    else
      set_error("トリガIDが正しくありません。")
      redirect_to(root_path)
      return false
    end
  end

  def set_notice(message)
    flash[:notice] = @flash_notice = message
    flash[:error]  = @flash_error  = nil
  end

  def set_error(message)
    flash[:notice] = @flash_notice = nil
    flash[:error]  = @flash_error  = message
  end

  def set_error_now(message)
    flash.now[:notice] = @flash_notice = nil
    flash.now[:error]  = @flash_error  = message
  end

  def send_rss(rss)
    send_data(rss.to_s, :type => "application/rss+xml", :disposition => "inline")
  end
end

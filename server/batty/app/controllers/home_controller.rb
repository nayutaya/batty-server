
# ホーム
class HomeController < ApplicationController
  # GET /
  def index
    @user = User.find_by_nickname("yu-yan") # FIXME: ログインユーザに変更
    @devices = @user.devices.sort_by(&:name) # FIXME: order by句に変更
  end
end

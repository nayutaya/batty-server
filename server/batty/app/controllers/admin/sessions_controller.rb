
# セッション管理
class Admin::SessionsController < Admin::BaseController
  # GET /admin/sessions
  def index
    @sessions = Session.paginate(
      :order    => "sessions.updated_at DESC, sessions.id DESC",
      :page     => params[:page],
      :per_page => 20)
  end
end

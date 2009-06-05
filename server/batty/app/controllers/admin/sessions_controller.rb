
# セッション管理
class Admin::SessionsController < Admin::BaseController
  verify_method_post :only => [:cleanup]

  # GET /admin/sessions
  def index
    @sessions = Session.paginate(
      :order    => "sessions.updated_at DESC, sessions.id DESC",
      :page     => params[:page],
      :per_page => 20)
  end

  # POST /admin/sessions/cleanup
  def cleanup
    Session.cleanup(3.days)
    redirect_to(:action => "index")
  end
end

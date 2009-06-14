
# イベント履歴
class EventsController < ApplicationController
  before_filter :authentication
  before_filter :authentication_required

  # GET /events
  def index
    @events = @login_user.events.paginate(
      :include  => [:device],
      :order    => "events.observed_at DESC, events.id DESC",
      :page     => params[:page],
      :per_page => 40)
  end
end

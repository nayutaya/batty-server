
# エネルギー履歴
class EnergiesController < ApplicationController
  before_filter :authentication
  before_filter :authentication_required

  # GET /energies
  def index
    @energies = @login_user.energies.paginate(
      :include  => [:device],
      :order    => "energies.observed_at DESC, energies.id DESC",
      :page     => params[:page],
      :per_page => 20)
  end
end

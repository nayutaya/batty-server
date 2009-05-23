
# デバイス
class DevicesController < ApplicationController
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:create])
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_device_id, :only => [:show]
  before_filter :specified_device_belongs_to_login_user, :only => [:show]

  # GET /devices/new
  def new
    @edit_form = DeviceEditForm.new
  end

  # POST /devices/create
  def create
    @edit_form = DeviceEditForm.new(params[:edit_form])

    if @edit_form.valid?
      @device = Device.new(@edit_form.to_device_hash)
      @device.device_token = Device.create_unique_device_token
      @device.user_id      = @login_user.id
      @device.save!

      set_notice("デバイスを追加しました。")
      redirect_to(root_path)
    else
      set_error_now("入力内容を確認してください。")
      render(:action => "new")
    end
  end

  # GET /device/:device_id
  def show
    @triggers = @device.triggers.all(
      :order => "triggers.level ASC, triggers.id ASC")
    @energies = @device.energies.paginate(
      :order    => "energies.observed_at DESC, energies.id DESC",
      :page     => 1,
      :per_page => 10)
    @events = @device.events.paginate(
      :order    => "events.observed_at DESC, events.id DESC",
      :page     => 1,
      :per_page => 10)
  end
end

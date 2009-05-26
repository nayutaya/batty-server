
# デバイス
class DevicesController < ApplicationController
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:create, :update])
  before_filter :authentication, :except => [:destroy]
  before_filter :authentication_required, :except => [:destroy]
  before_filter :required_param_device_id, :only => [:show, :edit, :update, :delete]
  before_filter :specified_device_belongs_to_login_user, :only => [:show, :edit, :update, :delete]

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

  # GET /device/:device_id/edit
  def edit
    @edit_form = DeviceEditForm.new(
      :name           => @device.name,
      :device_icon_id => @device.device_icon_id)
  end

  # POST /device/:device_id/update
  def update
    @edit_form = DeviceEditForm.new(params[:edit_form])

    @device.attributes = @edit_form.to_device_hash

    if @edit_form.valid? && @device.save
      set_notice("デバイスを更新しました。")
      redirect_to(device_path(:device_id => @device.id))
    else
      set_error_now("入力内容を確認してください。")
      render(:action => "edit")
    end
  end

  # GET /device/:device_id/delete
  def delete
    # nop
  end

  # POST /device/:device_id/destroy
  # TODO: 実装せよ
end

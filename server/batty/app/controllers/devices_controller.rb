
# デバイス
class DevicesController < ApplicationController
  EditFormClass = DeviceEditForm

  verify_method_post :only => [:create, :update, :destroy]
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_device_id, :only => [:show, :edit, :update, :delete, :destroy, :energies, :events]
  before_filter :specified_device_belongs_to_login_user, :only => [:show, :edit, :update, :delete, :destroy, :energies, :events]

  # GET /devices/new
  def new
    @edit_form = EditFormClass.new
  end

  # POST /devices/create
  def create
    @edit_form = EditFormClass.new(params[:edit_form])

    @device = @login_user.devices.build
    @device.attributes = @edit_form.to_device_hash

    if @edit_form.valid? && @device.save
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
    @edit_form = EditFormClass.new(
      :name           => @device.name,
      :device_icon_id => @device.device_icon_id)
  end

  # POST /device/:device_id/update
  def update
    @edit_form = EditFormClass.new(params[:edit_form])

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
  def destroy
    @device.destroy

    set_notice("デバイスを削除しました。")
    redirect_to(root_path)
  end

  # GET /device/:device_id/energies
  def energies
    @energies = @device.energies.paginate(
      :order    => "energies.observed_at DESC, energies.id DESC",
      :page     => params[:page],
      :per_page => 40)
  end

  # GET /device/:device_id/events
  def events
    @events = @device.events.paginate(
      :order    => "events.observed_at DESC, events.id DESC",
      :page     => params[:page],
      :per_page => 40)
  end
end

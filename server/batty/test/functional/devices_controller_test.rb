
require 'test_helper'

class DevicesControllerTest < ActionController::TestCase
  def setup
    @yuya        = users(:yuya)
    @yuya_pda    = devices(:yuya_pda)
    @shinya_note = devices(:shinya_note)

    @edit_form = DeviceEditForm.new(
      :name           => "name",
      :device_icon_id => device_icons(:note).id)

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "devices"}

    assert_routing("/devices/new",    base.merge(:action => "new"))
    assert_routing("/devices/create", base.merge(:action => "create"))

    assert_routing("/device/1234567890",         base.merge(:action => "show",    :device_id => "1234567890"))
    assert_routing("/device/1234567890/edit",    base.merge(:action => "edit",    :device_id => "1234567890"))
    assert_routing("/device/1234567890/update",  base.merge(:action => "update",  :device_id => "1234567890"))
    assert_routing("/device/1234567890/delete",  base.merge(:action => "delete",  :device_id => "1234567890"))
    assert_routing("/device/1234567890/destroy", base.merge(:action => "destroy", :device_id => "1234567890"))

    assert_equal("/device/1234567890", device_path(:device_id => "1234567890"))
  end

  test "GET new" do
    get :new

    assert_response(:success)
    assert_template("new")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(
      DeviceEditForm.new.attributes,
      assigns(:edit_form).attributes)
  end

  test "GET new, abnormal, no login" do
    session_logout

    get :new

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create" do
    assert_equal(true, @edit_form.valid?)

    assert_difference("Device.count", +1) {
      post :create, :edit_form => @edit_form.attributes
    }

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(
      @edit_form.attributes,
      assigns(:edit_form).attributes)

    assert_equal(@yuya.id,                  assigns(:device).user_id)
    assert_equal(@edit_form.name,           assigns(:device).name)
    assert_equal(@edit_form.device_icon_id, assigns(:device).device_icon_id)
  end

  test "POST create, invalid form" do
    @edit_form.name = nil
    assert_equal(false, @edit_form.valid?)

    assert_difference("Device.count", 0) {
      post :create, :edit_form => @edit_form.attributes
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error
  end

  test "GET create, abnormal, method not allowed" do
    get :create

    assert_response(405)
    assert_template(nil)
  end

  test "POST create, abnormal, no login" do
    session_logout

    post :create

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET show" do
    get :show, :device_id => @yuya_pda.id

    assert_response(:success)
    assert_template("show")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))

    assert_equal(@yuya_pda.triggers.size, assigns(:triggers).size)
    assert_equal(true, assigns(:triggers).map(&:device).all? { |d| d == @yuya_pda })
    assert_equal(
      assigns(:triggers).sort_by { |t| [t.level, t.id] },
      assigns(:triggers))

    assert_equal( 1, assigns(:energies).current_page)
    assert_equal(10, assigns(:energies).per_page)
    assert_equal(true, assigns(:energies).map(&:device).all? { |d| d == @yuya_pda })
    assert_equal(
      assigns(:energies).sort_by { |e| [e.observed_at, e.id] }.reverse,
      assigns(:energies))

    assert_equal( 1, assigns(:events).current_page)
    assert_equal(10, assigns(:events).per_page)
    assert_equal(true, assigns(:events).map(&:device).all? { |d| d == @yuya_pda })
    assert_equal(
      assigns(:events).sort_by { |e| [e.observed_at, e.id] }.reverse,
      assigns(:events))
  end

  test "GET show, abnormal, no login" do
    session_logout

    get :show, :device_id => @yuya_pda.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET show, abnormal, no device id" do
    get :show, :device_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET show, abnormal, other's device" do
    get :show, :device_id => @shinya_note.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit" do
    get :edit, :device_id => @yuya_pda.id

    assert_response(:success)
    assert_template("edit")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))

    assert_equal(@yuya_pda.name,           assigns(:edit_form).name)
    assert_equal(@yuya_pda.device_icon_id, assigns(:edit_form).device_icon_id)
  end

  test "GET edit, abnormal, no login" do
    session_logout

    get :edit

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit, abnormal, no device id" do
    get :edit, :device_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit, abnormal, other's device" do
    get :edit, :device_id => @shinya_note.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update" do
    @edit_form.name = "name"
    assert_equal(true, @edit_form.valid?)

    post :update, :device_id => @yuya_pda.id, :edit_form => @edit_form.attributes

    assert_response(:redirect)
    assert_redirected_to(:controller => "devices", :action => "show", :device_id => @yuya_pda.id)
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))

    assert_equal(
      @edit_form.attributes,
      assigns(:edit_form).attributes)

    @yuya_pda.reload
    assert_equal(@edit_form.name,           @yuya_pda.name)
    assert_equal(@edit_form.device_icon_id, @yuya_pda.device_icon_id)
  end

  test "POST update, invalid form" do
    @edit_form.name = nil
    assert_equal(false, @edit_form.valid?)

    post :update, :device_id => @yuya_pda.id, :edit_form => @edit_form.attributes

    assert_response(:success)
    assert_template("edit")
    assert_flash_error

    @yuya_pda.reload
    assert_not_equal(@edit_form.name, @yuya_pda.name)
  end

  test "GET update, abnormal, method not allowed" do
    get :update

    assert_response(405)
    assert_template(nil)
  end

  test "POST update, abnormal, no login" do
    session_logout

    post :update

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update, abnormal, no device id" do
    post :update, :device_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update, abnormal, other's device" do
    post :update, :device_id => @shinya_note.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete" do
    get :delete, :device_id => @yuya_pda.id

    assert_response(:success)
    assert_template("delete")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))
  end

  test "GET delete, abnormal, no login" do
    session_logout

    get :delete

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, no device id" do
    get :delete, :device_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, other's device" do
    get :delete, :device_id => @shinya_note.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy" do
    assert_difference("Device.count", -1) {
      post :destroy, :device_id => @yuya_pda.id
    }

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))

    assert_equal(nil, Device.find_by_id(@yuya_pda.id))
  end

  test "GET destroy, abnormal, method not allowed" do
    get :destroy

    assert_response(405)
    assert_template(nil)
  end

  test "POST destroy, abnormal, no login" do
    session_logout

    post :destroy

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, no device id" do
    post :destroy, :device_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, other's device" do
    post :destroy, :device_id => @shinya_note.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end
end

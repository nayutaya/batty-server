# -*- coding: utf-8 -*-

require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  def setup
    @yuya = users(:yuya)
  end

  test "routes" do
    base = {:controller => "home"}

    assert_routing("/", base.merge(:action => "index"))

    assert_equal("/", root_path)
  end

  test "GET index, yuya" do
    session_login(@yuya)

    get :index

    assert_response(:success)
    assert_template("index")
    assert_logged_in(@yuya)

    assert_equal(@yuya.devices.size, assigns(:devices).size)
    assert_equal(true, assigns(:devices).all? { |device| device.user == @yuya })
    assert_equal(
      assigns(:devices).sort_by { |d| [d.name, d.id] },
      assigns(:devices))

    assert_equal(@yuya.energies.size, assigns(:energies).total_entries)
    assert_equal( 1, assigns(:energies).current_page)
    assert_equal(10, assigns(:energies).per_page)
    assert_equal(true, assigns(:energies).all? { |e| e.device.user == @yuya })
    assert_equal(
      assigns(:energies).sort_by { |e| [e.observed_at, e.id] }.reverse,
      assigns(:energies))

    assert_equal(@yuya.events.size, assigns(:events).total_entries)
    assert_equal( 1, assigns(:events).current_page)
    assert_equal(10, assigns(:events).per_page)
    assert_equal(true, assigns(:events).all? { |e| e.device.user == @yuya })
    assert_equal(
      assigns(:events).sort_by { |e| [e.observed_at, e.id] }.reverse,
      assigns(:events))
  end

  test "GET index, shinya" do
    session_login(users(:shinya))

    get :index

    assert_response(:success)
    assert_template("index")
    assert_logged_in(users(:shinya))
  end

  test "GET index, no login" do
    session_logout

    get :index

    assert_response(:success)
    assert_template("index")   
    assert_not_logged_in

    assert_equal(nil, assigns(:devices))
    assert_equal(nil, assigns(:energies))
    assert_equal(nil, assigns(:events))
  end
end

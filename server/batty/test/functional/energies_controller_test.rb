
require 'test_helper'

class EnergiesControllerTest < ActionController::TestCase
  def setup
    @yuya = users(:yuya)

    session_login(@yuya)
  end
  test "routes" do
    base = {:controller => "energies"}

    assert_routing("/energies", base.merge(:action => "index"))
  end

  test "GET index" do
    get :index

    assert_response(:success)
    assert_template("index")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya.energies.size, assigns(:energies).total_entries)
    assert_equal( 1, assigns(:energies).current_page)
    assert_equal(20, assigns(:energies).per_page)
    assert_equal(true, assigns(:energies).all? { |e| e.device.user == @yuya })
    assert_equal(
      assigns(:energies).sort_by { |e| [e.observed_at, e.id] }.reverse,
      assigns(:energies))
  end

  test "GET index, page 2" do
    get :index, :page => 2

    assert_response(:success)
    assert_template("index")
    assert_flash_empty

    assert_equal( 2, assigns(:energies).current_page)
    assert_equal(20, assigns(:energies).per_page)
  end
  test "GET index, abnormal, no login" do
    session_logout

    get :index

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end
end

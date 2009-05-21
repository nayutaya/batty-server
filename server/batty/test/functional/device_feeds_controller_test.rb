
require 'test_helper'

class DeviceFeedsControllerTest < ActionController::TestCase
  def setup
    @yuya_pda    = devices(:yuya_pda)
    @shinya_note = devices(:shinya_note)
  end

  test "routes" do
    base = {:controller => "device_feeds"}

    assert_routing("/device/token/01234567/energies.rdf", base.merge(:action => "energies", :device_token => "01234567"))
    assert_routing("/device/token/89abcdef/energies.rdf", base.merge(:action => "energies", :device_token => "89abcdef"))
    assert_routing("/device/token/01234567/events.rdf",   base.merge(:action => "events", :device_token => "01234567"))
    assert_routing("/device/token/89abcdef/events.rdf",   base.merge(:action => "events", :device_token => "89abcdef"))
  end

  test "GET energies" do
    get :energies, :device_token => @yuya_pda.device_token

    assert_response(:success)
    assert_template(nil)
    assert_equal("application/rss+xml", @response.content_type)

    assert_equal(@yuya_pda, assigns(:device))

    energies = assigns(:energies)
    assert_equal([@yuya_pda], energies.map(&:device).uniq)
    assert_equal(energies.sort_by { |e| [-e.observed_at.to_i, -e.id] }, energies)
    assert_equal( 1, energies.current_page)
    assert_equal(10, energies.per_page)
  end

  test "GET energies, other device" do
    get :energies, :device_token => @shinya_note.device_token

    assert_response(:success)
    assert_template(nil)

    assert_equal(@shinya_note, assigns(:device))
  end

  test "GET energies, abnormal, no device token" do
    get :energies, :device_token => nil

    assert_response(404)
    assert_template(nil)
  end

  test "GET events" do
    get :events, :device_token => @yuya_pda.device_token

    assert_response(:success)
    assert_template(nil)
    assert_equal("application/rss+xml", @response.content_type)

    assert_equal(@yuya_pda, assigns(:device))

    events = assigns(:events)
    assert_equal([@yuya_pda], events.map(&:device).uniq)
    assert_equal(events.sort_by { |e| [-e.observed_at.to_i, -e.id] }, events)
    assert_equal( 1, events.current_page)
    assert_equal(10, events.per_page)
  end

  test "GET events, abnormal, no device token" do
    get :events, :device_token => nil

    assert_response(404)
    assert_template(nil)
  end
end

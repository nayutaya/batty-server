
require 'test_helper'

class DeviceFeedsControllerTest < ActionController::TestCase
  def setup
    @yuya_pda    = devices(:yuya_pda)
    @shinya_note = devices(:shinya_note)
  end

  test "routes" do
    base = {:controller => "device_feeds"}

    assert_routing("/device/token/0123456789abcdef/energies.rdf", base.merge(:action => "energies_rdf", :device_token => "0123456789abcdef"))
    assert_routing("/device/token/0123456789abcdef/energies.csv", base.merge(:action => "energies_csv", :device_token => "0123456789abcdef"))
    assert_routing("/device/token/0123456789abcdef/events.rdf",   base.merge(:action => "events_rdf", :device_token => "0123456789abcdef"))
    assert_routing("/device/token/0123456789abcdef/events.csv",   base.merge(:action => "events_csv", :device_token => "0123456789abcdef"))
  end

  test "GET energies_rdf" do
    get :energies_rdf, :device_token => @yuya_pda.device_token

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

  test "GET energies_rdf, other device" do
    get :energies_rdf, :device_token => @shinya_note.device_token

    assert_response(:success)
    assert_template(nil)

    assert_equal(@shinya_note, assigns(:device))
  end

  test "GET energies_rdf, abnormal, invalid device token" do
    get :energies_rdf, :device_token => "0"

    assert_response(404)
    assert_template(nil)
  end

  test "GET energies_csv" do
    get :energies_csv, :device_token => @yuya_pda.device_token

    assert_response(:success)
    assert_template(nil)
    assert_equal("text/csv", @response.content_type)

    assert_equal(@yuya_pda, assigns(:device))

    energies = assigns(:energies)
    assert_equal(@yuya_pda.energies.size, energies.size)
    assert_equal(true, energies.all? { |e| e.device == @yuya_pda })
    assert_equal(
      energies.sort_by { |e| [e.observed_at.to_i, e.id] }.reverse,
      energies)
  end

  test "GET energies_csv, abnormal, invalid device token" do
    get :energies_csv, :device_token => "0"

    assert_response(404)
    assert_template(nil)
  end

  test "GET events_rdf" do
    get :events_rdf, :device_token => @yuya_pda.device_token

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

  test "GET events_rdf, abnormal, invalie device token" do
    get :events_rdf, :device_token => "0"

    assert_response(404)
    assert_template(nil)
  end

  test "GET events_csv" do
    get :events_csv, :device_token => @yuya_pda.device_token

    assert_response(:success)
    assert_template(nil)
    assert_equal("text/csv", @response.content_type)

    assert_equal(@yuya_pda, assigns(:device))

    events = assigns(:events)
    assert_equal(@yuya_pda.events.size, events.size)
    assert_equal(true, events.all? { |e| e.device == @yuya_pda })
    assert_equal(
      events.sort_by { |e| [e.observed_at.to_i, e.id] }.reverse,
      events)
  end

  test "GET events_csv, abnormal, invalie device token" do
    get :events_csv, :device_token => "0"

    assert_response(404)
    assert_template(nil)
  end
end

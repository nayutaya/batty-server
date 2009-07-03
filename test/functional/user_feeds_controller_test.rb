
require 'test_helper'

class UserFeedsControllerTest < ActionController::TestCase
  def setup
    @yuya   = users(:yuya)
    @shinya = users(:shinya)
  end

  test "routes" do
    base = {:controller => "user_feeds"}

    assert_routing("/user/token/0123456789abcdef/energies.rss", base.merge(:action => "energies_rss", :user_token => "0123456789abcdef"))
    assert_routing("/user/token/0123456789abcdef/energies.csv", base.merge(:action => "energies_csv", :user_token => "0123456789abcdef"))
    assert_routing("/user/token/0123456789abcdef/events.rss",   base.merge(:action => "events_rss", :user_token => "0123456789abcdef"))
    assert_routing("/user/token/0123456789abcdef/events.csv",   base.merge(:action => "events_csv", :user_token => "0123456789abcdef"))
  end

  test "GET energies_rss" do
    get :energies_rss, :user_token => @yuya.user_token

    assert_response(:success)
    assert_template(nil)
    assert_equal("application/rss+xml", @response.content_type)

    assert_equal(@yuya, assigns(:user))

    energies = assigns(:energies)
    assert_equal([@yuya], energies.map(&:device).map(&:user).uniq)
    assert_equal(energies.sort_by { |e| [-e.observed_at.to_i, -e.id] }, energies)
    assert_equal( 1, energies.current_page)
    assert_equal(10, energies.per_page)
  end

  test "GET energies_rss, other user" do
    get :energies_rss, :user_token => @shinya.user_token

    assert_response(:success)
    assert_template(nil)

    assert_equal(@shinya, assigns(:user))
  end

  test "GET energies_rss, abnormal, invalid user token" do
    get :energies_rss, :user_token => "0"

    assert_response(404)
    assert_template(nil)
  end

  test "GET energies_csv" do
    get :energies_csv, :user_token => @yuya.user_token

    assert_response(:success)
    assert_template(nil)
    assert_equal("text/csv", @response.content_type)

    assert_equal(@yuya, assigns(:user))

    energies = assigns(:energies)
    assert_equal(@yuya.energies.size, energies.size)
    assert_equal(true, energies.all? { |e| e.device.user == @yuya })
    assert_equal(
      energies.sort_by { |e| [e.observed_at.to_i, e.id] }.reverse,
      energies)
  end

  test "GET energies_csv, abnormal, invalid user token" do
    get :energies_csv, :user_token => "0"

    assert_response(404)
    assert_template(nil)
  end

  test "GET events_rss" do
    get :events_rss, :user_token => @yuya.user_token

    assert_response(:success)
    assert_template(nil)
    assert_equal("application/rss+xml", @response.content_type)

    assert_equal(@yuya, assigns(:user))

    events = assigns(:events)
    assert_equal([@yuya], events.map(&:device).map(&:user).uniq)
    assert_equal(events.sort_by { |e| [-e.observed_at.to_i, -e.id] }, events)
    assert_equal( 1, events.current_page)
    assert_equal(10, events.per_page)
  end

  test "GET events_rss, abnormal, invalid user token" do
    get :events_rss, :user_token => "0"

    assert_response(404)
    assert_template(nil)
  end

  test "GET events_csv" do
    get :events_csv, :user_token => @yuya.user_token

    assert_response(:success)
    assert_template(nil)
    assert_equal("text/csv", @response.content_type)

    assert_equal(@yuya, assigns(:user))

    events = assigns(:events)
    assert_equal(@yuya.events.size, events.size)
    assert_equal(true, events.all? { |e| e.device.user == @yuya })
    assert_equal(
      events.sort_by { |e| [e.observed_at.to_i, e.id] }.reverse,
      events)
  end

  test "GET events_csv, abnormal, invalid user token" do
    get :events_csv, :user_token => "0"

    assert_response(404)
    assert_template(nil)
  end
end

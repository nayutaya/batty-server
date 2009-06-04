
require 'test_helper'

class UserFeedsControllerTest < ActionController::TestCase
  def setup
    @yuya   = users(:yuya)
    @shinya = users(:shinya)
  end

  test "routes" do
    base = {:controller => "user_feeds"}

    assert_routing("/user/token/01234567/energies.rdf", base.merge(:action => "energies", :user_token => "01234567"))
    assert_routing("/user/token/89abcdef/energies.rdf", base.merge(:action => "energies", :user_token => "89abcdef"))
    assert_routing("/user/token/01234567/events.rdf",   base.merge(:action => "events", :user_token => "01234567"))
    assert_routing("/user/token/89abcdef/events.rdf",   base.merge(:action => "events", :user_token => "89abcdef"))
  end

  test "GET energies" do
    get :energies, :user_token => @yuya.user_token

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

  test "GET energies, other user" do
    get :energies, :user_token => @shinya.user_token

    assert_response(:success)
    assert_template(nil)

    assert_equal(@shinya, assigns(:user))
  end

  test "GET energies, abnormal, invalid user token" do
    get :energies, :user_token => "0"

    assert_response(404)
    assert_template(nil)
  end

  test "GET events" do
    get :events, :user_token => @yuya.user_token

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

  test "GET events, abnormal, invalid user token" do
    get :events, :user_token => "0"

    assert_response(404)
    assert_template(nil)
  end
end

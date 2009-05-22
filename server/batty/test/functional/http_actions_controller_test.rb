
require 'test_helper'

class HttpActionsControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "http_actions"}

    assert_routing("/device/1234567890/trigger/2345678901/acts/http/new",    base.merge(:action => "new", :device_id => "1234567890", :trigger_id => "2345678901"))
    assert_routing("/device/1234567890/trigger/2345678901/acts/http/create", base.merge(:action => "create", :device_id => "1234567890", :trigger_id => "2345678901"))
  end

  test "GET new" do
    # TODO: 実装せよ
  end

  test "GET new, abnormal, no login" do
    # TODO: 実装せよ
  end

  test "GET new, abnormal, no device id" do
    # TODO: 実装せよ
  end

  test "GET new, abnormal, no trigger" do
    # TODO: 実装せよ
  end

  test "GET new, abnormal, other's device" do
    # TODO: 実装せよ
  end

  test "GET new, abnormal, other's trigger" do
    # TODO: 実装せよ
  end

  test "POST create" do
    # TODO: 実装せよ
  end

  test "POST create, invalid form" do
    # TODO: 実装せよ
  end

  test "GET create, abnormal, method not allowed" do
    # TODO: 実装せよ
  end

  test "POST create, abnormal, no login" do
    # TODO: 実装せよ
  end

  test "POST create, abnormal, no device id" do
    # TODO: 実装せよ
  end

  test "POST create, abnormal, no trigger id" do
    # TODO: 実装せよ
  end

  test "POST create, abnormal, other's device" do
    # TODO: 実装せよ
  end

  test "POST create, abnormal, other's trigger" do
    # TODO: 実装せよ
  end
end

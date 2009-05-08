# -*- coding: utf-8 -*-

require 'test_helper'

class OpenIdCredentialTest < ActiveSupport::TestCase
  def setup
    @yuya_livedoor  = open_id_credentials(:yuya_livedoor)
    @shinya_example = open_id_credentials(:shinya_example)
    @klass = OpenIdCredential
    @basic = @klass.new(
      :user         => users(:yuya),
      :identity_url => @yuya_livedoor.identity_url)
  end

  #
  # 関連
  #

  test "belongs_to :user" do
    assert_equal(
      users(:yuya),
      @yuya_livedoor.user)

    assert_equal(
      users(:shinya),
      @shinya_example.user)
  end

  #
  # 検証
  #

  test "all fixtures are valid" do
    assert_equal(true, @klass.all.all?(&:valid?))
  end

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :identity_url" do
    @basic.identity_url = nil
    assert_equal(false, @basic.valid?)
    assert_equal(true, @basic.errors.invalid?(:identity_url))
  end

  test "validates_length_of :identity_url" do
    @basic.identity_url = 'http://example.com/' + 'a' * 182
    assert_equal(false, @basic.valid?)
    assert_equal(true, @basic.errors.invalid?(:identity_url))
  end
end

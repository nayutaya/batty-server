# -*- coding: utf-8 -*-

require 'test_helper'

class OpenIdCredentialTest < ActiveSupport::TestCase
  def setup
    @klass = OpenIdCredential
    @basic = @klass.new(
      :user_id      => users(:yuya).id,
      :identity_url => "http://example.jp/identity_url")

    @yuya_livedoor  = open_id_credentials(:yuya_livedoor)
    @shinya_example = open_id_credentials(:shinya_example)
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
    @basic.identity_url = "http://example.com/" + "a" * 182
    assert_equal(201, @basic.identity_url.size)

    assert_equal(false, @basic.valid?)
    assert_equal(true, @basic.errors.invalid?(:identity_url))
  end

  test "validates_format_of :identity_url" do
    [
     ["http://example.com/foo",  true,  false],
     ["https://example.com/foo", true,  false],
     ["ftp://example.com/foo",   false, true ],
     ["HTTP://EXAMPLE.COM/foo",  false, true ],
    ].each{|value, expected1, expected2|
      @basic.identity_url = value
      assert_equal(expected1, @basic.valid?)
      assert_equal(expected2, @basic.errors.invalid?(:identity_url))
    }
  end

  test "validates_uniqueness_of :identity_url, on create" do
    @basic.identity_url = @yuya_livedoor.identity_url
    assert_equal(false, @basic.valid?)
  end

  test "validates_uniqueness_of :identity_url, on update" do
    @yuya_livedoor.identity_url = @shinya_example.identity_url
    assert_equal(false, @yuya_livedoor.valid?)
  end

  test "validates_each :user_id" do
    srand(0)
    user = users(:yuya)
    create_record = proc {
      user.open_id_credentials.create!(
        :identity_url => "http://example.jp/identity_url#{rand(1000)}")
    }

    assert_nothing_raised {
      (10 - user.open_id_credentials.size).times {
        record = create_record[]
        record.save!
      }
    }
    assert_raise(ActiveRecord::RecordInvalid) {
      create_record[]
    }
  end

  #
  # インスタンスメソッド
  #

  test "login!" do
    time = Time.local(2010, 1, 1)
    assert_equal(nil, @shinya_example.loggedin_at)
    Kagemusha::DateTime.at(time) { @shinya_example.login! }
    assert_equal(time, @shinya_example.reload.loggedin_at)
  end
end

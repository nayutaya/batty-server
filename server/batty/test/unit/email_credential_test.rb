# -*- coding: utf-8 -*-

require 'test_helper'

class EmailCredentialTest < ActiveSupport::TestCase
  def setup
    @yuya_gmail   = email_credentials(:yuya_gmail)
    @risa_example = email_credentials(:risa_example)
    @klass = EmailCredential
    @basic = @klass.new(
      :activation_token => '0' * 20,
      :user             => users(:yuya),
      :email            => 'foo@example.com',
      :password         => 'password',
      :hashed_password  => 'hashed_password')
  end

  #
  # 関連
  #

  test "belongs_to :user" do
    assert_equal(
      users(:yuya),
      @yuya_gmail.user)

    assert_equal(
      users(:risa),
      @risa_example.user)
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

  test "validates_presence_of :email" do
    @basic.email = nil
    assert_equal(false, @basic.valid?)
    assert_equal(true, @basic.errors.invalid?(:email))
  end

  test "validates_length_of :email" do
    @basic.email = "#{'a' * 189}@example.com" # 201 文字
    assert_equal(false, @basic.valid?)
    assert_equal(true, @basic.errors.invalid?(:email))
  end

  test "validates_presence_of :activation_token" do
    @basic.activation_token = nil
    assert_equal(false, @basic.valid?)
    assert_equal(true, @basic.errors.invalid?(:activation_token))
  end
end

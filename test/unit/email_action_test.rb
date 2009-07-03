
require 'test_helper'

class EmailActionTest < ActiveSupport::TestCase
  def setup
    @klass = EmailAction
    @basic = @klass.new(
      :trigger_id => triggers(:yuya_pda_ge90).id,
      :email      => email_addresses(:yuya_gmail).email,
      :subject    => "subject",
      :body       => "body")
  end

  #
  # 関連
  #

  test "belongs_to :trigger" do
    assert_equal(
      triggers(:yuya_pda_ge90),
      email_actions(:yuya_pda_ge90_1).trigger)

    assert_equal(
      triggers(:shinya_note_ne0),
      email_actions(:shinya_note_ne0_1).trigger)
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

  test "validates_presence_of :trigger_id" do
    @basic.trigger_id = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :email" do
    @basic.email = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :subject" do
    @basic.subject = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :body" do
    @basic.body = nil
    assert_equal(false, @basic.valid?)
  end

=begin
  # MEMO: 通知先メールアドレスに存在することの検証を追加したため、テストできない
  test "validates_length_of :email" do
    # MEMO: 下記の制約を満たしつつ、文字列長の検証のテストを行う
    #       * ローカルパートは64文字以内
    #       * ドメインパートは255文字以内
    #       * ドメインパートのドットで区切られたパートは63文字以内

    [
      ["a@b.c.d.com", 11, true ],
      [["a" * 64 + "@" + "b" * 63, "c" * 63, "d" * 3, "com"].join("."), 200, true ],
      [["a" * 64 + "@" + "b" * 63, "c" * 63, "d" * 4, "com"].join("."), 201, false],
    ].each { |value, length, expected|
      assert_equal(length, value.size)
      @basic.email = value
      assert_equal(expected, @basic.valid?)
    }
  end
=end

  test "validates_length_of :subject" do
    [
      ["あ" *   1, true ],
      ["あ" * 200, true ],
      ["あ" * 201, false],
    ].each { |value, expected|
      @basic.subject = value
      assert_equal(expected, @basic.valid?)
    }
  end

  test "validates_length_of :body" do
    [
      ["あ" *    1, true ],
      ["あ" * 1000, true ],
      ["あ" * 1001, false],
    ].each { |value, expected|
      @basic.body = value
      assert_equal(expected, @basic.valid?)
    }
  end

=begin
  # MEMO: 通知先メールアドレスに存在することの検証を追加したため、テストできない
  test "validates_email_format_of :email" do
    [
      ["foo@example.com",   true ],
      ["foo@example.co.jp", true ],
      ["foo@example",       false],
    ].each { |value, expected|
      @basic.email = value
      assert_equal(
        {:in => value, :out => expected},
        {:in => value, :out => @basic.valid?})
    }
  end
=end

  test "validates_each :trigger_id" do
    trigger = triggers(:yuya_pda_ge90)
    create_record = proc {
      trigger.email_actions.create!(
        :enable  => true,
        :email   => email_addresses(:yuya_gmail).email,
        :subject => "subject",
        :body    => "body")
    }

    assert_nothing_raised {
      (5 - trigger.email_actions.size).times {
        record = create_record[]
        record.save!
      }
    }
    assert_raise(ActiveRecord::RecordInvalid) {
      create_record[]
    }
  end

  test "validates_each :email" do
    @basic.trigger_id = triggers(:yuya_pda_ge90).id
    @basic.email      = email_addresses(:yuya_gmail).email
    assert_equal(true, @basic.valid?)

    @basic.trigger_id = triggers(:yuya_pda_ge90).id
    @basic.email      = email_addresses(:yuya_example).email
    assert_equal(false, @basic.valid?)
  end

  #
  # 名前付きスコープ
  #

  test "enable" do
    assert_equal(true,  (@klass.count > @klass.enable.count))
    assert_equal(false, @klass.all.all?(&:enable?))
    assert_equal(true,  @klass.enable.all.all?(&:enable?))
  end
end

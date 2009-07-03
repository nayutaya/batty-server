
# アクティベーションメーラ
class ActivationMailer < ActionMailer::Base
  include ActionMailerUtil

  SubjectPrefix = "[batty] "
  FromAddress   = "batty-no-reply@nayutaya.jp"

  def self.create_request_for_signup_params(options)
    options = options.dup
    recipients     = options.delete(:recipients)     || raise(ArgumentError)
    activation_url = options.delete(:activation_url) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :subject    => SubjectPrefix + "ユーザ登録",
      :from       => FromAddress,
      :recipients => recipients,
      :body       => {:activation_url => activation_url},
    }
  end

  def self.create_complete_for_signup_params(options)
    options = options.dup
    recipients = options.delete(:recipients) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :subject    => SubjectPrefix + "ユーザ登録完了",
      :from       => FromAddress,
      :recipients => recipients,
      :body       => {},
    }
  end

  def self.create_request_for_credential_params(options)
    options = options.dup
    recipients     = options.delete(:recipients)     || raise(ArgumentError)
    activation_url = options.delete(:activation_url) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :subject    => SubjectPrefix + "メールアドレス認証登録",
      :from       => FromAddress,
      :recipients => recipients,
      :body       => {:activation_url => activation_url},
    }
  end

  def self.create_complete_for_credential_params(options)
    options = options.dup
    recipients = options.delete(:recipients) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :subject    => SubjectPrefix + "メールアドレス認証登録完了",
      :from       => FromAddress,
      :recipients => recipients,
      :body       => {},
    }
  end

  def self.create_request_for_notice_params(options)
    options = options.dup
    recipients     = options.delete(:recipients)     || raise(ArgumentError)
    activation_url = options.delete(:activation_url) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :subject    => SubjectPrefix + "通知先メールアドレス登録",
      :from       => FromAddress,
      :recipients => recipients,
      :body       => {:activation_url => activation_url},
    }
  end

  def self.create_complete_for_notice_params(options)
    options = options.dup
    recipients = options.delete(:recipients) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :subject    => SubjectPrefix + "通知先メールアドレス登録完了",
      :from       => FromAddress,
      :recipients => recipients,
      :body       => {},
    }
  end

  def request_for_signup(options)
    build_message(self.class.create_request_for_signup_params(options))
  end

  def complete_for_signup(options)
    build_message(self.class.create_complete_for_signup_params(options))
  end

  def request_for_credential(options)
    build_message(self.class.create_request_for_credential_params(options))
  end

  def complete_for_credential(options)
    build_message(self.class.create_complete_for_credential_params(options))
  end

  def request_for_notice(options)
    build_message(self.class.create_request_for_notice_params(options))
  end

  def complete_for_notice(options)
    build_message(self.class.create_complete_for_notice_params(options))
  end
end

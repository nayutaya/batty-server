# -*- coding: utf-8 -*-

# メール認証情報サインアップ
class Signup::EmailController < ApplicationController
  EditFormClass = EmailCredentialEditForm

  filter_parameter_logging :password
  verify_method_post :only => [:validate, :create, :activate]
  before_filter :clear_session_user_id, :only => [:index, :validate, :validated, :create, :created, :activation, :activate, :activated]
  before_filter :clear_session_signup_form, :only => [:index, :validate, :activation, :activate, :activated]

  # GET /signup/email
  def index
    @signup_form = EditFormClass.new
  end

  # POST /signup/email/validate
  def validate
    @signup_form = EditFormClass.new(params[:signup_form])

    if @signup_form.valid?
      session[:signup_form] = @signup_form.attributes
      redirect_to(:action => "validated")
    else
      @signup_form.password              = nil
      @signup_form.password_confirmation = nil
      set_error_now("入力内容を確認してください。")
      render(:action => "index")
    end
  end

  # GET /signup/email/validated
  def validated
    @signup_form = EditFormClass.new(session[:signup_form])

    if @signup_form.valid?
      render
    else
      set_error_now("入力内容を確認してください。")
      render(:action => "index")
    end
  end

  # POST /signup/email/create
  def create
    @signup_form = EditFormClass.new(session[:signup_form])

    if @signup_form.valid?
      # TODO: エラー処理
      User.transaction {
        @user = User.new
        @user.user_token = User.create_unique_user_token
        @user.nickname   = nil
        @user.save!

        @credential = @user.email_credentials.build
        @credential.attributes       = @signup_form.to_email_credential_hash
        @credential.activation_token = EmailCredential.create_unique_activation_token
        @credential.save!
      }

      @activation_url = url_for(
        :only_path        => false,
        :controller       => "signup/email",
        :action           => "activation",
        :activation_token => @credential.activation_token)

      request_options = {
        :recipients     => @credential.email,
        :activation_url => @activation_url,
      }

      # FIXME: 非スレッド化
      @email_queue = Queue.new
      Thread.new {
        begin
          @email_queue << SignupActivationMailer.deliver_request(request_options)
        rescue Exception => e
          logger.add(
            logger.class::ERROR,
            format("%s\n%s: %s\n%s\n%s", "-" * 50, e.class.name, e.message, e.backtrace[0, 5].join("\n"), "-" * 50))
        end
      }

      redirect_to(:action => "created")
    else
      set_error_now("入力内容を確認してください。")
      render(:action => "index")
    end
  end

  # GET /signup/email/created
  def created
    @signup_form = EditFormClass.new(session[:signup_form])
    @credential  = EmailCredential.find_by_email(@signup_form.email)
  end

  # GET /signup/email/activation/:activation_token
  # FIXME: URLの見直し
  # FIXME: 無効なアクティベーションキー、アクティベーション済みのキーはフィルタで弾く
  def activation
    @credential = EmailCredential.find_by_activation_token(params[:activation_token])
    @activated  = @credential.try(:activated?)
  end

  # POST /signup/email/activate
  # FIXME: URLの見直し
  # FIXME: 無効なアクティベーションキー、アクティベーション済みのキーはフィルタで弾く
  def activate
    @credential = EmailCredential.find_by_activation_token(params[:activation_token])

    unless @credential
      set_error("無効なアクティベーションキーです。")
      redirect_to(root_path)
      return
    end

    if @credential.activated?
      set_error("既に本登録されています。")
      redirect_to(root_path)
      return
    end

    @credential.activate!

    # TODO: テスト
    # TODO: 非同期化
    SignupActivationMailer.deliver_complete(
      :recipients => @credential.email)

    redirect_to(:action => "activated")
  end

  # GET /signup/email/activated
  # FIXME: URLの見直し
  # FIXME: 無効なアクティベーションキー、アクティベーション済みのキーはフィルタで弾く
  def activated
    # nop
  end

  private

  def clear_session_user_id
    session[:user_id] = nil
    return true
  end

  def clear_session_signup_form
    session[:signup_form] = nil
    return true
  end
end

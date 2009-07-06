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

    @user = User.new
    @credential = @user.email_credentials.build
    @credential.attributes = @signup_form.to_email_credential_hash

    if @signup_form.valid? && @user.save
      @activation_url = url_for(
        :only_path        => false,
        :controller       => "signup/email",
        :action           => "activation",
        :activation_token => @credential.activation_token)

      # TODO: テスト
      # MEMO: 即時性を優先し、非同期化しない
      ActivationMailer.deliver_request_for_signup(
        :recipients     => @credential.email,
        :activation_url => @activation_url)

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
    # MEMO: 即時性を優先し、非同期化しない
    ActivationMailer.deliver_complete_for_signup(
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
